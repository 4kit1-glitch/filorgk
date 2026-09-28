#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT/lib/core/00_logging.sh"
source "$ROOT/lib/functions/0_move.sh"
source "$ROOT/lib/core/02_backup.sh"

TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

export SCRIPT_DIR="$TEST_DIR"
export LOGS_DIR="$TEST_DIR/logs"
export BACKUP_DIR="$TEST_DIR/backups"
export current_info_log_path="$LOGS_DIR/info.log"
export current_err_log_path="$LOGS_DIR/err.log"
mkdir -p "$LOGS_DIR" "$BACKUP_DIR"

src_file="$TEST_DIR/source.txt"
printf 'hello\n' > "$src_file"

# Backup should create a valid archive path before any move happens.
export current_backup_path="$BACKUP_DIR/backup.tar"
export found_files_store_path="$TEST_DIR/files.list"
printf '%s\n' "$src_file" > "$found_files_store_path"
backup_files <<<'Y'
[[ -f "$current_backup_path" ]] || {
  echo 'backup_files did not create an archive' >&2
  exit 1
}

# Move should create destination directories automatically.
move_file "$src_file" "$TEST_DIR/archive/subdir"
[[ -f "$TEST_DIR/archive/subdir/source.txt" ]] || {
  echo 'move_file failed to create destination directories' >&2
  exit 1
}

echo 'regression checks passed'
