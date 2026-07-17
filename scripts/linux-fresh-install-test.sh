#!/usr/bin/env bash
set -euo pipefail

#MISE description="Run a Linux fresh-install test in disposable Docker containers"
#USAGE flag "--target <target>" help="Linux target to run: ubuntu, omarchy, or all" default="all"
#USAGE flag "--ubuntu-image <image>" help="Docker image for the Ubuntu target" default="ubuntu:24.04"
#USAGE flag "--omarchy-image <image>" help="Docker image for the Omarchy-like Arch target" default="archlinux/archlinux:latest"
#USAGE flag "--prefix <prefix>" help="Prefix for generated container names and cleanup" default="dotfiles-linux-test-"
#USAGE flag "--platform <platform>" help="Docker platform to request, for example linux/arm64"
#USAGE flag "--disable-mise-tools <tools>" help="Comma-separated tools to pass through as MISE_DISABLE_TOOLS for smoke runs"
#USAGE flag "--keep-container" help="Do not delete containers after the run"
#USAGE flag "--cleanup" help="Delete containers matching --prefix, then exit"

TARGET="${usage_target:-all}"
UBUNTU_IMAGE="${usage_ubuntu_image:-ubuntu:24.04}"
OMARCHY_IMAGE="${usage_omarchy_image:-archlinux/archlinux:latest}"
PREFIX="${usage_prefix:-dotfiles-linux-test-}"
PLATFORM="${usage_platform:-}"
MISE_DISABLE_TOOLS_VALUE="${usage_disable_mise_tools:-${MISE_DISABLE_TOOLS:-}}"
KEEP_CONTAINER="${usage_keep_container:-false}"
CLEANUP="${usage_cleanup:-false}"
TAR_BIN="${TAR_BIN:-/usr/bin/tar}"
TEST_USER="dotfiles"
LOG_DIR=""
CURRENT_CONTAINER=""

usage_error() {
  echo "error: $*" >&2
  echo "usage: mise run linux:fresh-install -- [--target ubuntu|omarchy|all] [--cleanup] [--keep-container]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || usage_error "--target requires a value"
      TARGET="$2"
      shift 2
      ;;
    --target=*)
      TARGET="${1#--target=}"
      shift
      ;;
    --ubuntu-image)
      [[ $# -ge 2 ]] || usage_error "--ubuntu-image requires a value"
      UBUNTU_IMAGE="$2"
      shift 2
      ;;
    --ubuntu-image=*)
      UBUNTU_IMAGE="${1#--ubuntu-image=}"
      shift
      ;;
    --omarchy-image)
      [[ $# -ge 2 ]] || usage_error "--omarchy-image requires a value"
      OMARCHY_IMAGE="$2"
      shift 2
      ;;
    --omarchy-image=*)
      OMARCHY_IMAGE="${1#--omarchy-image=}"
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
    --platform)
      [[ $# -ge 2 ]] || usage_error "--platform requires a value"
      PLATFORM="$2"
      shift 2
      ;;
    --platform=*)
      PLATFORM="${1#--platform=}"
      shift
      ;;
    --disable-mise-tools)
      [[ $# -ge 2 ]] || usage_error "--disable-mise-tools requires a value"
      MISE_DISABLE_TOOLS_VALUE="$2"
      shift 2
      ;;
    --disable-mise-tools=*)
      MISE_DISABLE_TOOLS_VALUE="${1#--disable-mise-tools=}"
      shift
      ;;
    --keep-container)
      KEEP_CONTAINER=true
      shift
      ;;
    --cleanup)
      CLEANUP=true
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

case "$TARGET" in
  ubuntu | omarchy | all) ;;
  *) usage_error "--target must be one of: ubuntu, omarchy, all" ;;
esac

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

cleanup_containers() {
  local found=false
  local container

  while IFS= read -r container; do
    [[ -n $container ]] || continue
    [[ $container == "$PREFIX"* ]] || continue

    found=true
    echo "Deleting $container..."
    docker rm -f "$container" >/dev/null 2>&1 || true
  done < <(docker ps -a --format '{{.Names}}')

  if [[ $found == false ]]; then
    echo "No containers found with prefix $PREFIX"
  fi
}

cleanup_current_container() {
  [[ -n $CURRENT_CONTAINER ]] || return 0

  if [[ $KEEP_CONTAINER == true ]]; then
    echo "Keeping container $CURRENT_CONTAINER"
    echo "Logs: $LOG_DIR"
    return
  fi

  echo "Deleting container $CURRENT_CONTAINER..."
  docker rm -f "$CURRENT_CONTAINER" >/dev/null 2>&1 || true
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

docker_exec() {
  docker exec "$CURRENT_CONTAINER" "$@"
}

docker_exec_user() {
  local -a env_args=(
    --env CI=1
    --env HOME="/home/$TEST_USER"
    --env MISE_YES=1
  )

  if [[ -n $MISE_DISABLE_TOOLS_VALUE ]]; then
    env_args+=(--env "MISE_DISABLE_TOOLS=$MISE_DISABLE_TOOLS_VALUE")
  fi

  docker exec \
    --user "$TEST_USER" \
    "${env_args[@]}" \
    --workdir "/home/$TEST_USER/dotfiles" \
    "$CURRENT_CONTAINER" \
    "$@"
}

bootstrap_container() {
  local target="$1"

  case "$target" in
    ubuntu)
      docker_exec env DEBIAN_FRONTEND=noninteractive apt-get update
      docker_exec env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git gpg sudo tar zsh
      ;;
    omarchy)
      docker_exec bash -lc "if grep -q '^#DisableSandboxSyscalls' /etc/pacman.conf; then sed -i 's/^#DisableSandboxSyscalls/DisableSandboxSyscalls/' /etc/pacman.conf; elif ! grep -q '^DisableSandboxSyscalls' /etc/pacman.conf; then sed -i '/^\[options\]/a DisableSandboxSyscalls' /etc/pacman.conf; fi"
      docker_exec pacman --noconfirm --needed -Sy ca-certificates curl git gnupg sudo tar zsh
      ;;
  esac

  docker_exec useradd -m -s /bin/bash "$TEST_USER"
  docker_exec bash -lc "printf '%s ALL=(ALL) NOPASSWD:ALL\n' '$TEST_USER' >/etc/sudoers.d/$TEST_USER && chmod 0440 /etc/sudoers.d/$TEST_USER"
}

copy_repo_into_container() {
  local archive_path="$1"

  docker cp "$archive_path" "$CURRENT_CONTAINER:/tmp/dotfiles.tar.gz"
  docker_exec bash -lc "mkdir -p /home/$TEST_USER/dotfiles && tar -xzf /tmp/dotfiles.tar.gz -C /home/$TEST_USER/dotfiles && chown -R $TEST_USER:$TEST_USER /home/$TEST_USER/dotfiles"
}

validate_install() {
  # shellcheck disable=SC2016 # Expand $HOME inside the container, not on the host.
  docker_exec_user bash -lc 'test -L "$HOME/.zshrc"'
  # shellcheck disable=SC2016 # Expand $HOME inside the container, not on the host.
  docker_exec_user bash -lc 'test -L "$HOME/.zshenv"'
  # shellcheck disable=SC2016 # Expand $HOME inside the container, not on the host.
  docker_exec_user bash -lc 'test -L "$HOME/.config/nvim"'
  docker_exec_user bash -lc 'zsh -lic "echo zsh-ok"'
  docker_exec_user bash -lc 'mise --version'
  docker_exec_user bash -lc 'mise bootstrap packages status --missing'
}

run_target() {
  local target="$1"
  local image="$2"
  local repo_dir="$3"
  local name
  name="${PREFIX}${target}-$(date +%Y%m%d%H%M%S)-$$"
  local target_log_dir="$LOG_DIR/$target"
  local archive_path="$target_log_dir/dotfiles.tar.gz"
  local manifest_path="$target_log_dir/archive-manifest.txt"
  local -a docker_args=(run --detach --name "$name")

  mkdir -p "$target_log_dir"

  if [[ -n $PLATFORM ]]; then
    docker_args+=(--platform "$PLATFORM")
  fi

  docker_args+=("$image" sleep infinity)

  create_repo_archive "$repo_dir" "$archive_path" "$manifest_path"

  echo "Starting $target container from $image..."
  CURRENT_CONTAINER="$(docker "${docker_args[@]}")"
  # Use the generated name for cleanup/log messages rather than Docker's ID.
  CURRENT_CONTAINER="$name"

  bootstrap_container "$target"
  copy_repo_into_container "$archive_path"

  echo "Running setup.sh in $target container..."
  docker_exec_user bash -lc './setup.sh'

  echo "Validating $target install..."
  validate_install

  if [[ $KEEP_CONTAINER != true ]]; then
    rm -f "$archive_path" "$manifest_path"
  fi

  echo "$target fresh-install test passed."
  cleanup_current_container
  CURRENT_CONTAINER=""
}

main() {
  require_command docker
  require_command git
  require_command "$TAR_BIN"

  if [[ $CLEANUP == true ]]; then
    cleanup_containers
    exit 0
  fi

  LOG_DIR="${TMPDIR:-/tmp}/dotfiles-linux/$PREFIX$(date +%Y%m%d%H%M%S)-$$"
  local repo_dir
  repo_dir="$(repo_root)"

  trap cleanup_current_container EXIT

  case "$TARGET" in
    ubuntu)
      run_target ubuntu "$UBUNTU_IMAGE" "$repo_dir"
      ;;
    omarchy)
      run_target omarchy "$OMARCHY_IMAGE" "$repo_dir"
      ;;
    all)
      run_target ubuntu "$UBUNTU_IMAGE" "$repo_dir"
      run_target omarchy "$OMARCHY_IMAGE" "$repo_dir"
      ;;
  esac

  echo "Linux fresh-install tests passed."
  echo "Logs: $LOG_DIR"
}

main "$@"
