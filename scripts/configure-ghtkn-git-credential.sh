#!/usr/bin/env bash

set -euo pipefail

gitconfig_file=${GHTKN_GITCONFIG_FILE:-"$HOME/.gitconfig.local"}
include_file=${GHTKN_GITCONFIG_INCLUDE_FILE:-"$HOME/.config/git/ghtkn.gitconfig"}
credential_section='credential.https://github.com'

unset_config_value() {
  local status

  if git config --file "$gitconfig_file" "$@"; then
    return 0
  else
    status=$?
  fi

  # git config uses status 5 when the requested key or value is absent.
  if [[ $status -eq 5 ]]; then
    return 0
  fi
  return "$status"
}

usage() {
  cat <<'EOF'
Usage: configure-ghtkn-git-credential.sh [--remove]

Configure ghtkn as the Git credential helper for github.com in
an isolated config included by ~/.gitconfig.local. Set GHTKN_GITCONFIG_FILE
or GHTKN_GITCONFIG_INCLUDE_FILE to operate on other files.

Options:
  --remove  Remove the github.com-specific ghtkn credential configuration.
EOF
}

case ${1:-} in
  '')
    ;;
  --remove)
    unset_config_value --fixed-value --unset-all include.path "$include_file"
    unset_config_value --fixed-value --unset-all "$credential_section.helper" '!ghtkn git-credential'
    unset_config_value --fixed-value --unset-all "$credential_section.helper" ''
    unset_config_value --unset-all ghtkn.enabled
    rm -f "$include_file"
    printf 'Removed ghtkn Git credential configuration from %s\n' "$gitconfig_file"
    exit 0
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if ! command -v ghtkn >/dev/null 2>&1; then
  echo 'ghtkn is not installed or is not in PATH. Install it with mise first.' >&2
  exit 1
fi

gitconfig_dir=$(dirname "$gitconfig_file")
include_dir=$(dirname "$include_file")
mkdir -p "$gitconfig_dir" "$include_dir"

if [[ ! -e $gitconfig_file ]]; then
  (umask 077 && touch "$gitconfig_file")
fi

temporary=$(mktemp "$include_dir/.ghtkn.gitconfig.XXXXXX")
trap 'rm -f "$temporary"' EXIT
chmod 600 "$temporary"

printf '%s\n' \
  '[credential "https://github.com"]' \
  '  helper =' \
  '  helper = !ghtkn git-credential' \
  '  useHttpPath = true' \
  '[ghtkn]' \
  '  enabled = true' >"$temporary"

mv "$temporary" "$include_file"
trap - EXIT

# Clean up the exact values written by the earlier direct-section provisioner.
unset_config_value --fixed-value --unset-all "$credential_section.helper" '!ghtkn git-credential'
unset_config_value --fixed-value --unset-all "$credential_section.helper" ''
unset_config_value --unset-all ghtkn.gitCredentialEnabled

if ! git config --file "$gitconfig_file" --fixed-value --get-all include.path "$include_file" >/dev/null 2>&1; then
  git config --file "$gitconfig_file" --add include.path "$include_file"
fi

printf 'Configured ghtkn for github.com via %s\n' "$include_file"
printf 'Set GHTKN_GITHUB_TOKEN only when an explicit PAT override is required.\n'
