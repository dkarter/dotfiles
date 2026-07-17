#!/usr/bin/env bash
set -euo pipefail

#MISE description="Run a fresh-install test in an ephemeral Tart macOS VM"
#USAGE flag "--base <source>" help="Tart source VM or OCI image to clone" default="ghcr.io/cirruslabs/macos-tahoe-base:latest"
#USAGE flag "--name <name>" help="Name for the ephemeral VM"
#USAGE flag "--prefix <prefix>" help="Prefix for generated VM names and cleanup" default="dotfiles-tart-test-"
#USAGE flag "--cpu <count>" help="CPU count for the VM" default="4"
#USAGE flag "--memory <megabytes>" help="Memory for the VM in MB" default="8192"
#USAGE flag "--timeout <seconds>" help="Seconds to wait for VM boot and guest agent" default="300"
#USAGE flag "--guest-script <path>" help="Guest script path inside this repo" default="scripts/tart-guest-install-core.sh"
#USAGE flag "--install-mode <mode>" help="Guest install path to run: core, task, or setup" default="core"
#USAGE flag "--keep-vm" help="Do not stop/delete the VM after the run"
#USAGE flag "--cleanup" help="Stop and delete VMs matching --prefix, then exit"
#USAGE flag "--graphics" help="Open the Tart UI immediately instead of trying --no-graphics first"
#USAGE flag "--skip-mise-tools" help="Pass through to guest core install"
#USAGE flag "--skip-zinit-plugins" help="Pass through to guest core install"
#USAGE flag "--skip-nvim" help="Pass through to guest core install"
#USAGE flag "--with-completions" help="Pass through to guest core install"
#USAGE complete "base" run="tart list --quiet"

BASE="${usage_base:-ghcr.io/cirruslabs/macos-tahoe-base:latest}"
PREFIX="${usage_prefix:-dotfiles-tart-test-}"
VM_NAME="${usage_name:-}"
CPU="${usage_cpu:-4}"
MEMORY="${usage_memory:-8192}"
TIMEOUT="${usage_timeout:-300}"
GUEST_SCRIPT="${usage_guest_script:-scripts/tart-guest-install-core.sh}"
INSTALL_MODE="${usage_install_mode:-core}"
KEEP_VM="${usage_keep_vm:-false}"
CLEANUP="${usage_cleanup:-false}"
GRAPHICS="${usage_graphics:-false}"
SKIP_MISE_TOOLS="${usage_skip_mise_tools:-false}"
SKIP_ZINIT_PLUGINS="${usage_skip_zinit_plugins:-false}"
SKIP_NVIM="${usage_skip_nvim:-false}"
WITH_COMPLETIONS="${usage_with_completions:-false}"
TAR_BIN="${TAR_BIN:-/usr/bin/tar}"
LOG_DIR=""
VM_CREATED=false
GUEST_TRANSFER_DIR="/Volumes/My Shared Files/transfer"

usage_error() {
  echo "error: $*" >&2
  echo "usage: mise run tart:fresh-install -- [--keep-vm] [--cleanup] [--graphics] [--base SOURCE] [--install-mode MODE]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      [[ $# -ge 2 ]] || usage_error "--base requires a value"
      BASE="$2"
      shift 2
      ;;
    --base=*)
      BASE="${1#--base=}"
      shift
      ;;
    --name)
      [[ $# -ge 2 ]] || usage_error "--name requires a value"
      VM_NAME="$2"
      shift 2
      ;;
    --name=*)
      VM_NAME="${1#--name=}"
      shift
      ;;
    --prefix)
      [[ $# -ge 2 ]] || usage_error "--prefix requires a value"
      PREFIX="$2"
      shift 2
      ;;
    --prefix=*)
      PREFIX="${1#--prefix=}"
      shift
      ;;
    --cpu)
      [[ $# -ge 2 ]] || usage_error "--cpu requires a value"
      CPU="$2"
      shift 2
      ;;
    --cpu=*)
      CPU="${1#--cpu=}"
      shift
      ;;
    --memory)
      [[ $# -ge 2 ]] || usage_error "--memory requires a value"
      MEMORY="$2"
      shift 2
      ;;
    --memory=*)
      MEMORY="${1#--memory=}"
      shift
      ;;
    --timeout)
      [[ $# -ge 2 ]] || usage_error "--timeout requires a value"
      TIMEOUT="$2"
      shift 2
      ;;
    --timeout=*)
      TIMEOUT="${1#--timeout=}"
      shift
      ;;
    --guest-script)
      [[ $# -ge 2 ]] || usage_error "--guest-script requires a value"
      GUEST_SCRIPT="$2"
      shift 2
      ;;
    --guest-script=*)
      GUEST_SCRIPT="${1#--guest-script=}"
      shift
      ;;
    --install-mode)
      [[ $# -ge 2 ]] || usage_error "--install-mode requires a value"
      INSTALL_MODE="$2"
      shift 2
      ;;
    --install-mode=*)
      INSTALL_MODE="${1#--install-mode=}"
      shift
      ;;
    --keep-vm)
      KEEP_VM=true
      shift
      ;;
    --cleanup)
      CLEANUP=true
      shift
      ;;
    --graphics)
      GRAPHICS=true
      shift
      ;;
    --skip-mise-tools)
      SKIP_MISE_TOOLS=true
      shift
      ;;
    --skip-zinit-plugins)
      SKIP_ZINIT_PLUGINS=true
      shift
      ;;
    --skip-nvim)
      SKIP_NVIM=true
      shift
      ;;
    --with-completions)
      WITH_COMPLETIONS=true
      shift
      ;;
    --)
      shift
      [[ $# -eq 0 ]] || usage_error "unexpected arguments after --: $*"
      break
      ;;
    *)
      usage_error "unknown argument: $1"
      ;;
  esac
done

[[ -n $PREFIX ]] || usage_error "--prefix cannot be empty"

case "$CPU" in
  '' | *[!0-9]*) usage_error "--cpu must be a positive integer" ;;
esac

case "$MEMORY" in
  '' | *[!0-9]*) usage_error "--memory must be a positive integer" ;;
esac

case "$TIMEOUT" in
  '' | *[!0-9]*) usage_error "--timeout must be a positive integer" ;;
esac

case "$INSTALL_MODE" in
  core | task | setup) ;;
  *) usage_error "--install-mode must be one of: core, task, setup" ;;
esac

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

stop_delete_vm() {
  local vm="$1"

  tart stop "$vm" --timeout 20 >/dev/null 2>&1 || true
  tart delete "$vm" >/dev/null 2>&1 || true
}

stop_vm() {
  local vm="$1"

  tart stop "$vm" --timeout 20 >/dev/null 2>&1 || true
}

cleanup_dangling_vms() {
  local found=false
  local vm

  while IFS= read -r vm; do
    [[ -n $vm ]] || continue
    [[ $vm == "$PREFIX"* ]] || continue

    found=true
    echo "Cleaning $vm..."
    stop_delete_vm "$vm"
  done < <(tart list --quiet)

  if [[ $found == false ]]; then
    echo "No VMs found with prefix $PREFIX"
  fi
}

cleanup_current_vm() {
  if [[ $VM_CREATED != true ]]; then
    return
  fi

  if [[ $KEEP_VM == true ]]; then
    echo "Keeping VM $VM_NAME"
    echo "Logs: $LOG_DIR"
    return
  fi

  echo "Deleting VM $VM_NAME..."
  stop_delete_vm "$VM_NAME"
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

wait_for_guest() {
  local vm="$1"
  local run_pid="$2"
  local deadline=$((SECONDS + TIMEOUT))
  local ip=""

  while ((SECONDS < deadline)); do
    if ! kill -0 "$run_pid" >/dev/null 2>&1; then
      return 1
    fi

    ip="$(tart ip --wait 5 "$vm" 2>/dev/null || true)"
    if [[ -n $ip ]] && tart exec "$vm" true >/dev/null 2>&1; then
      echo "$ip"
      return 0
    fi

    sleep 2
  done

  return 1
}

create_repo_archive() {
  local repo_dir="$1"
  local archive_path="$2"
  local manifest_path="$3"

  echo "Creating clean repo archive..."
  (
    cd "$repo_dir"

    git ls-files -z --cached --others --exclude-standard \
      | while IFS= read -r -d '' path; do
        # The core test does not install these app bundles, and their Icon\r
        # files produce unreadable macOS tar headers over this transfer path.
        case "$path" in
          iterm/BTop.app/* | iterm/TerminalVim.app/*)
            continue
            ;;
        esac

        if [[ -e $path || -L $path ]]; then
          printf '%s\0' "$path"
        fi
      done >"$manifest_path"

    if [[ -e .git || -L .git ]]; then
      printf '%s\0' .git >>"$manifest_path"
    fi

    COPYFILE_DISABLE=1 "$TAR_BIN" -czf "$archive_path" --no-mac-metadata --null -T "$manifest_path"
  )
}

start_vm() {
  local vm="$1"
  local mode="$2"
  local transfer_dir="$3"
  local log_file="$4"
  local -a args=(run --no-audio --dir="transfer:${transfer_dir}:ro")

  if [[ $mode == "headless" ]]; then
    args+=(--no-graphics)
  fi

  args+=("$vm")

  echo "Starting $vm ($mode)..." >&2
  nohup tart "${args[@]}" >"$log_file" 2>&1 &
  echo "$!"
}

main() {
  require_command tart
  require_command git
  require_command "$TAR_BIN"

  if [[ $CLEANUP == true ]]; then
    cleanup_dangling_vms
    exit 0
  fi

  local repo_dir
  repo_dir="$(repo_root)"

  if [[ ! -f "$repo_dir/$GUEST_SCRIPT" ]]; then
    echo "error: guest script not found: $repo_dir/$GUEST_SCRIPT" >&2
    exit 1
  fi

  if [[ -z $VM_NAME ]]; then
    VM_NAME="${PREFIX}$(date +%Y%m%d%H%M%S)-$$"
  fi

  LOG_DIR="${TMPDIR:-/tmp}/dotfiles-tart/$VM_NAME"
  mkdir -p "$LOG_DIR"
  local archive_path="$LOG_DIR/dotfiles.tar.gz"
  local manifest_path="$LOG_DIR/archive-manifest.txt"

  local run_pid=""

  trap cleanup_current_vm EXIT

  create_repo_archive "$repo_dir" "$archive_path" "$manifest_path"

  echo "Cloning $BASE to $VM_NAME..."
  tart clone "$BASE" "$VM_NAME"
  VM_CREATED=true

  echo "Configuring $VM_NAME with $CPU CPUs and ${MEMORY}MB RAM..."
  tart set "$VM_NAME" --cpu "$CPU" --memory "$MEMORY"

  local ip=""
  if [[ $GRAPHICS != true ]]; then
    run_pid="$(start_vm "$VM_NAME" headless "$LOG_DIR" "$LOG_DIR/tart-run-headless.log")"
    if ! ip="$(wait_for_guest "$VM_NAME" "$run_pid")"; then
      echo "Headless boot did not become ready; retrying with Tart UI."
      stop_vm "$VM_NAME"
      run_pid="$(start_vm "$VM_NAME" graphics "$LOG_DIR" "$LOG_DIR/tart-run-graphics.log")"
      ip="$(wait_for_guest "$VM_NAME" "$run_pid")"
    fi
  else
    run_pid="$(start_vm "$VM_NAME" graphics "$LOG_DIR" "$LOG_DIR/tart-run-graphics.log")"
    ip="$(wait_for_guest "$VM_NAME" "$run_pid")"
  fi

  echo "VM ready at $ip"
  echo "Extracting dotfiles archive in guest..."
  # shellcheck disable=SC2016 # Expand $HOME inside the guest shell, not on the host.
  tart exec "$VM_NAME" bash -lc 'rm -rf "$HOME/dotfiles" && mkdir -p "$HOME/dotfiles" && /usr/bin/tar -xzf "$1/dotfiles.tar.gz" -C "$HOME/dotfiles"' bash "$GUEST_TRANSFER_DIR"

  echo "Running guest install mode: $INSTALL_MODE"
  local -a guest_args=(--install-mode "$INSTALL_MODE")
  [[ $SKIP_MISE_TOOLS == true ]] && guest_args+=(--skip-mise-tools)
  [[ $SKIP_ZINIT_PLUGINS == true ]] && guest_args+=(--skip-zinit-plugins)
  [[ $SKIP_NVIM == true ]] && guest_args+=(--skip-nvim)
  [[ $WITH_COMPLETIONS == true ]] && guest_args+=(--with-completions)

  # shellcheck disable=SC2016 # Expand $HOME inside the guest shell, not on the host.
  if ((${#guest_args[@]})); then
    tart exec "$VM_NAME" bash -lc 'cd "$HOME/dotfiles" && DOTFILES_TART_GUEST_INSTALL=true exec bash "$@"' bash "$GUEST_SCRIPT" "${guest_args[@]}"
  else
    tart exec "$VM_NAME" bash -lc 'cd "$HOME/dotfiles" && DOTFILES_TART_GUEST_INSTALL=true exec bash "$@"' bash "$GUEST_SCRIPT"
  fi

  echo "Fresh-install $INSTALL_MODE test passed."
  if [[ $KEEP_VM != true ]]; then
    rm -f "$archive_path" "$manifest_path"
  fi
  echo "Logs: $LOG_DIR"
}

main "$@"
