#!/usr/bin/env bash

set -euo pipefail

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
source_db="$data_home/opencode/opencode-next.db"
destination_db="$data_home/opencode/opencode.db"
backup_dir=''
apply=false

usage() {
  cat <<'EOF'
Usage: import-opencode-sessions.sh [options]

Export sessions from an older OpenCode database and import them through the
current OpenCode session API. The script preserves session IDs, imports parents
before children, and skips IDs already present in the destination.

The default mode is a dry run. Both databases are backed up before OpenCode
opens either working copy. Transcript contents are streamed between OpenCode
commands and are not printed or stored as JSON files.

Options:
  --source-db PATH       Source database (default: opencode-next.db)
  --destination-db PATH  Destination database (default: opencode.db)
  --backup-dir PATH      Persistent backup directory used with --apply
  --apply                Import sessions into the destination database
  -h, --help             Show this help
EOF
}

while (($# > 0)); do
  case $1 in
    --source-db)
      source_db=${2:?--source-db requires a path}
      shift 2
      ;;
    --destination-db)
      destination_db=${2:?--destination-db requires a path}
      shift 2
      ;;
    --backup-dir)
      backup_dir=${2:?--backup-dir requires a path}
      shift 2
      ;;
    --apply)
      apply=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

for command in jq opencode sqlite3; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Required command is not available: %s\n' "$command" >&2
    exit 1
  fi
done

if [[ ! -f $source_db ]]; then
  printf 'Source database does not exist: %s\n' "$source_db" >&2
  exit 1
fi

if [[ ! -f $destination_db ]]; then
  printf 'Destination database does not exist: %s\n' "$destination_db" >&2
  exit 1
fi

canonical_path() {
  local path=$1
  local directory
  directory=$(cd "$(dirname "$path")" && pwd -P)
  printf '%s/%s\n' "$directory" "$(basename "$path")"
}

source_db=$(canonical_path "$source_db")
destination_db=$(canonical_path "$destination_db")
default_db=$(canonical_path "$data_home/opencode/opencode.db")

if [[ $source_db == "$destination_db" ]]; then
  echo 'Source and destination databases must be different.' >&2
  exit 1
fi

umask 077
workdir=$(mktemp -d "${TMPDIR:-/tmp}/opencode-session-import.XXXXXX")
service_was_running=false

cleanup() {
  local status=$?
  local file

  if [[ $service_was_running == true ]]; then
    opencode service start >/dev/null 2>&1 || true
  fi

  for file in "$workdir"/*; do
    [[ -e $file ]] || continue
    rm -f -- "$file"
  done
  rmdir "$workdir" 2>/dev/null || true
  exit "$status"
}
trap cleanup EXIT INT TERM

timestamp=$(date -u +%Y%m%dT%H%M%SZ)
if [[ $apply == true ]]; then
  if [[ -z $backup_dir ]]; then
    backup_dir="$(dirname "$destination_db")/session-import-backups/$timestamp"
  fi
  mkdir -p "$backup_dir"
  chmod 700 "$backup_dir"
  source_working_db="$backup_dir/source.db"
  destination_backup_db="$backup_dir/destination.db"
else
  source_working_db="$workdir/source.db"
  destination_backup_db="$workdir/destination.db"
fi

sqlite3 "$source_db" ".backup '$source_working_db'"
sqlite3 "$destination_db" ".backup '$destination_backup_db'"
chmod 600 "$source_working_db" "$destination_backup_db"

list_sessions() {
  local database=$1
  local output=$2
  local cursor=''
  local next_cursor
  local page_count
  local raw="$workdir/session-page.json"

  : >"$output"
  while true; do
    if [[ -n $cursor ]]; then
      OPENCODE_DB="$database" opencode api --standalone session.list \
        --param limit=1000 --param order=asc --param cursor="$cursor" >"$raw"
    else
      OPENCODE_DB="$database" opencode api --standalone session.list \
        --param limit=1000 --param order=asc >"$raw"
    fi

    jq -c '.data[] | {id, parentID, directory: .location.directory}' "$raw" >>"$output"
    page_count=$(jq '.data | length' "$raw")
    next_cursor=$(jq -r '.cursor.next // empty' "$raw")
    rm -f -- "$raw"

    if [[ $page_count -eq 0 || -z $next_cursor || $next_cursor == "$cursor" ]]; then
      break
    fi
    cursor=$next_cursor
  done
}

source_sessions="$workdir/source-sessions.jsonl"
destination_sessions="$workdir/destination-sessions.jsonl"
list_sessions "$source_working_db" "$source_sessions"
list_sessions "$destination_backup_db" "$destination_sessions"

source_count=$(wc -l <"$source_sessions" | tr -d ' ')
existing_count=$(jq -Rn \
  --slurpfile source "$source_sessions" \
  --slurpfile destination "$destination_sessions" \
  '[($source[] | .id)] as $source_ids | [($destination[] | .id) | select(. as $id | $source_ids | index($id))] | length')
import_count=$((source_count - existing_count))

printf 'Source sessions: %s\n' "$source_count"
printf 'Already present: %s\n' "$existing_count"
printf 'Sessions to import: %s\n' "$import_count"

if [[ $apply != true ]]; then
  echo 'Dry run complete. Run again with --apply to perform the import.'
  exit 0
fi

if [[ $destination_db == "$default_db" ]] && opencode service status >/dev/null 2>&1; then
  service_was_running=true
  opencode service stop >/dev/null
fi

completed="$workdir/completed-session-ids"
jq -r '.id' "$destination_sessions" >"$completed"

session_exists() {
  grep -Fqx -- "$1" "$completed"
}

source_has_session() {
  jq -e --arg id "$1" 'select(.id == $id)' "$source_sessions" >/dev/null
}

import_session() {
  local id=$1
  local parent_id
  local directory

  if session_exists "$id"; then
    return
  fi

  parent_id=$(jq -r --arg id "$id" 'select(.id == $id) | .parentID // empty' "$source_sessions")
  if [[ -n $parent_id ]] && source_has_session "$parent_id"; then
    import_session "$parent_id"
  elif [[ -n $parent_id ]] && ! session_exists "$parent_id"; then
    printf 'Cannot import %s because parent %s is unavailable.\n' "$id" "$parent_id" >&2
    exit 1
  fi

  directory=$(jq -r --arg id "$id" 'select(.id == $id) | .directory' "$source_sessions")
  OPENCODE_DB="$source_working_db" opencode session export --standalone "$id" \
    | OPENCODE_DB="$destination_db" opencode session import --standalone --directory "$directory" /dev/stdin \
      >"$workdir/import-result.json"
  rm -f -- "$workdir/import-result.json"
  printf '%s\n' "$id" >>"$completed"
}

while IFS= read -r id; do
  import_session "$id"
done < <(jq -r '.id' "$source_sessions")

verification="$workdir/verification-sessions.jsonl"
list_sessions "$destination_db" "$verification"
missing_count=$(jq -Rn \
  --slurpfile source "$source_sessions" \
  --slurpfile destination "$verification" \
  '[($destination[] | .id)] as $destination_ids | [($source[] | .id) | select(. as $id | $destination_ids | index($id) | not)] | length')

if [[ $missing_count -ne 0 ]]; then
  printf 'Import verification failed: %s source session(s) are missing.\n' "$missing_count" >&2
  exit 1
fi

printf 'Import complete. Imported %s session(s).\n' "$import_count"
printf 'Backups: %s\n' "$backup_dir"
