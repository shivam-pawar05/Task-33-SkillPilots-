#!/usr/bin/env bash
# Read-only presence checks only; this script does not perform a restore.
set -euo pipefail
: "${BASE_BACKUP_DIR:?Set BASE_BACKUP_DIR to the base-backup directory}"
: "${WAL_ARCHIVE_DIR:?Set WAL_ARCHIVE_DIR to the WAL archive directory}"
[[ -d "$BASE_BACKUP_DIR" ]] || { echo "Missing base backup directory" >&2; exit 1; }
[[ -d "$WAL_ARCHIVE_DIR" ]] || { echo "Missing WAL archive directory" >&2; exit 1; }
echo "Base backup directory exists: $BASE_BACKUP_DIR"
echo "WAL archive directory exists: $WAL_ARCHIVE_DIR"
echo "WAL files found: $(find "$WAL_ARCHIVE_DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')"
echo "Presence does not prove integrity or target-time coverage."
