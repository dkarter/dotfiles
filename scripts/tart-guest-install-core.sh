#!/usr/bin/env bash
set -euo pipefail

#MISE description="Run a dotfiles install flow inside a Tart macOS guest"
#USAGE flag "--install-mode <mode>" help="Install path to run: core, task, or setup" default="core"
#USAGE flag "--skip-mise-tools" help="Skip installing configured mise tools"
#USAGE flag "--skip-zinit-plugins" help="Skip warming/updating zinit plugins"
#USAGE flag "--skip-nvim" help="Skip Neovim plugin/package installation and validation"
#USAGE flag "--with-completions" help="Generate shell completions after tools install"

INSTALL_MODE="${usage_install_mode:-core}"
SKIP_MISE_TOOLS="${usage_skip_mise_tools:-false}"
SKIP_ZINIT_PLUGINS="${usage_skip_zinit_plugins:-false}"
SKIP_NVIM="${usage_skip_nvim:-false}"
WITH_COMPLETIONS="${usage_with_completions:-false}"

usage_error() {
  echo "error: $*" >&2
  echo "usage: mise run tart:guest:install-core -- [--install-mode MODE] [--skip-mise-tools] [--skip-zinit-plugins] [--skip-nvim]" >&2
  exit 2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --install-mode)
      [[ $# -ge 2 ]] || usage_error "--install-mode requires a value"
      INSTALL_MODE="$2"
      shift 2
      ;;
    --install-mode=*)
      INSTALL_MODE="${1#--install-mode=}"
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

case "$INSTALL_MODE" in
  core | task | setup) ;;
  *) usage_error "--install-mode must be one of: core, task, setup" ;;
esac

if [[ "$(uname)" != "Darwin" ]]; then
  echo "error: this guest install test expects macOS" >&2
  exit 1
fi

if [[ ${DOTFILES_TART_GUEST_INSTALL:-} != true ]]; then
  echo "error: this task is intended for the Tart guest harness" >&2
  echo "Run it through: mise run tart:fresh-install" >&2
  exit 1
fi

export CI=1
export MISE_YES=1
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/share/mise/shims:$PATH"

# The Tart base image ships an unmanaged gitconfig; model a clean dotfiles target.
rm -f "$HOME/.gitconfig"

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return
  fi

  echo "Installing Homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | NONINTERACTIVE=1 /bin/bash
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

ensure_task() {
  if command -v task >/dev/null 2>&1; then
    return
  fi

  echo "Installing Task..."
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://taskfile.dev/install.sh | sh -s -- -d -b "$HOME/.local/bin"
}

run_task() {
  echo "+ task $*"
  task "$@"
}

assert_symlink() {
  local path="$1"
  local expected_target="$2"

  if [[ ! -L $path ]]; then
    echo "error: expected symlink: $path" >&2
    exit 1
  fi

  if [[ "$(realpath "$path")" != "$expected_target" ]]; then
    echo "error: expected $path to resolve to $expected_target" >&2
    exit 1
  fi
}

run_core_install() {
  echo "Running core install path..."
  bash ./installer/shared.sh

  ensure_homebrew
  ensure_task

  run_task dot:create:dirs
  run_task mise:install
  run_task dot:symlink
  run_task op:install:ssh:agent
  run_task zinit:install
  run_task mac:set:defaults

  if [[ $SKIP_MISE_TOOLS != true ]]; then
    run_task mise:tools:install
  fi

  if [[ $SKIP_ZINIT_PLUGINS != true ]]; then
    run_task zinit:plugins:warm
  fi

  run_task fonts:sync

  if [[ $SKIP_MISE_TOOLS != true ]]; then
    run_task bat:sync
  fi

  if [[ $SKIP_NVIM != true ]]; then
    run_task nvim:install
  fi

  if [[ $WITH_COMPLETIONS == true ]]; then
    run_task completions:generate
  fi
}

run_task_install() {
  echo "Running Taskfile install path..."
  ensure_homebrew
  ensure_task
  run_task install
}

run_setup_install() {
  echo "Running setup.sh install path..."
  ./setup.sh
}

case "$INSTALL_MODE" in
  core) run_core_install ;;
  task) run_task_install ;;
  setup) run_setup_install ;;
esac

echo "Validating dotfiles install..."
assert_symlink "$HOME/.zshrc" "$HOME/dotfiles/zshrc"
assert_symlink "$HOME/.zshenv" "$HOME/dotfiles/zshenv"
assert_symlink "$HOME/.config/nvim" "$HOME/dotfiles/config/nvim"
assert_symlink "$HOME/.config/mise" "$HOME/dotfiles/config/mise"

zsh -lic 'echo zsh-ok'
mise --version
mise bootstrap dotfiles status --missing
mise bootstrap macos defaults status --missing

if [[ "$(defaults -currentHost read com.apple.controlcenter.plist BatteryShowPercentage 2>/dev/null)" != 1 ]]; then
  echo "error: expected the menu bar battery percentage to be enabled" >&2
  exit 1
fi

if [[ $SKIP_NVIM != true ]]; then
  mise exec -- nvim --headless '+qall'
fi

echo "Dotfiles install validation passed."
