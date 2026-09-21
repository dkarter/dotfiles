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

ensure_committed_github_backend() {
  local destination="$TARGET_DIR/mise.toml"

  if [[ ! -f $destination ]]; then
    return
  fi

  python3 - "$destination" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text(encoding="utf-8")

github_pattern = re.compile(r'(?m)^\s*"github:crate-ci/committed"\s*=\s*"[^"]+"\s*$')
legacy_patterns = [
    re.compile(r'(?m)^(\s*)committed\s*=\s*"([^"]+)"\s*$'),
    re.compile(r'(?m)^(\s*)"ubi:crate-ci/committed"\s*=\s*"([^"]+)"\s*$'),
]

if github_pattern.search(text):
    print("ok    mise.toml (committed uses github backend)")
    raise SystemExit(0)

for pattern in legacy_patterns:
    match = pattern.search(text)
    if match:
        indent, version = match.group(1), match.group(2)
        replacement = f'{indent}"github:crate-ci/committed" = "{version}"'
        updated = text[:match.start()] + replacement + text[match.end():]
        path.write_text(updated, encoding="utf-8")
        print("update mise.toml (committed -> github backend)")
        raise SystemExit(0)

if "[tools]" in text:
    updated = re.sub(
        r'(?m)^\[tools\]\s*$',
        '[tools]\n"github:crate-ci/committed" = "latest"',
        text,
        count=1,
    )
else:
    updated = text.rstrip("\n") + '\n\n[tools]\n"github:crate-ci/committed" = "latest"\n'

path.write_text(updated, encoding="utf-8")
print("update mise.toml (added committed github backend)")
PY
}

copy_template "mise.toml"
ensure_committed_github_backend
copy_template "dprint.json"
copy_template "hk.pkl"
copy_template "committed.toml"
copy_template "fnox.toml"

if [[ $WITH_RENOVATE == "true" ]]; then
  copy_template "renovate.json"
fi

cat <<'EOF'

Done.

Run in the target repository:
  mise install
  hk install --mise
  mise run fmt
  mise run fmt-check
EOF
