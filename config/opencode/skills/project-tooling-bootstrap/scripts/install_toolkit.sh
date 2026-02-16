#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="."
FORCE="false"
WITH_RENOVATE="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE="true"
      shift
      ;;
    --with-renovate)
      WITH_RENOVATE="true"
      shift
      ;;
    -h | --help)
      cat <<'EOF'
Usage:
  bash scripts/install_toolkit.sh [target-dir] [--with-renovate] [--force]

Options:
  --with-renovate  Copy renovate.json template
  --force          Overwrite existing files
EOF
      exit 0
      ;;
    *)
      TARGET_DIR="$1"
      shift
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$SKILL_DIR/assets/template"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [[ ! -d $TEMPLATE_DIR ]]; then
  echo "Template directory not found: $TEMPLATE_DIR" >&2
  exit 1
fi

if [[ ! -d $TARGET_DIR ]]; then
  echo "Target directory not found: $TARGET_DIR" >&2
  exit 1
fi

copy_template() {
  local relative_path="$1"
  local source="$TEMPLATE_DIR/$relative_path"
  local destination="$TARGET_DIR/$relative_path"

  if [[ ! -f $source ]]; then
    echo "Template file not found: $source" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$destination")"

  if [[ -f $destination ]]; then
    if cmp -s "$source" "$destination"; then
      echo "ok    $relative_path (already up to date)"
      return
    fi

    if [[ $FORCE != "true" ]]; then
      echo "skip  $relative_path (exists and differs; use --force to overwrite)"
      return
    fi

    cp "$source" "$destination"
    echo "update $relative_path"
    return
  fi

  cp "$source" "$destination"
  echo "copy  $relative_path"
}

copy_template "mise.toml"
copy_template "Taskfile.yml"
copy_template "taskfiles/ci.yml"
copy_template "dprint.json"
copy_template "lefthook.yml"
copy_template "committed.toml"

if [[ $WITH_RENOVATE == "true" ]]; then
  copy_template "renovate.json"
fi

cat <<'EOF'

Done.

Run in the target repository:
  mise install
  lefthook install
  task fmt
  task ci:fmt:check
EOF
