#!/usr/bin/env bash

# Exit codes:
#   0 — success
#   1 — target dir missing
#   2 — chmod failed
#   3 — mktemp/create tmp failed
#   4 — io error while processing file

set -euo pipefail
IFS=$'\n\t'

# constants:
TARGET_DIR="${HOME}/myfolder"
FILE2_PATH="${TARGET_DIR}/file2.txt"
NEW_PERMS="664"
OLD_PERMS="777"

# helpers:
log() { printf '%s\n' "$*"; }

# check folder:
check_target_dir() {
  if [ ! -d "$TARGET_DIR" ]; then
    log "Directory $TARGET_DIR not found."
    return 1
  fi
  return 0
}

# count files:
count_files() {
  local file_count
  file_count=$(find -- "$TARGET_DIR" -maxdepth 1 -type f -print | wc -l)
  log "Files in $TARGET_DIR: $file_count"
  return 0
}

# change permissions file2 777 --> 664:
change_permissions_if_needed() {
  if [ -f "$FILE2_PATH" ]; then
    local current_perms
    current_perms=$(stat -c '%a' -- "$FILE2_PATH" 2>/dev/null || echo "")
    if [ "$current_perms" = "$OLD_PERMS" ]; then
      if ! chmod "$NEW_PERMS" -- "$FILE2_PATH"; then
        log "ERROR: failed chmod on $FILE2_PATH"
        return 2
      fi
      log "Permissions for $FILE2_PATH changed from $OLD_PERMS to $NEW_PERMS"
    else
      log "Permissions for $FILE2_PATH: $current_perms"
    fi
  else
    log "File $FILE2_PATH not found — skipping permission check."
  fi
  return 0
}

# delete empty files:
delete_empty_files() {
  local found=0
  while IFS= read -r -d '' f; do
    printf '%s\n' "$f"
    found=1
  done < <(find -- "$TARGET_DIR" -maxdepth 1 -type f -empty -print0)

  if [ "$found" -eq 1 ]; then
    find -- "$TARGET_DIR" -maxdepth 1 -type f -empty -delete
    log "Deleted empty files above."
  else
    log "No empty files found."
  fi
  return 0
}

# leave only first line in files:
cut_files_to_first_line() {
  local file tmpfile
  while IFS= read -r -d '' file; do
    # if file empty — skip:
    if [ ! -s "$file" ]; then
      continue
    fi
    tmpfile=$(mktemp "${file}.XXXXXX") || {
      log "ERROR: mktemp failed for $file"
      return 3
    }
    # extract first line:
    if ! head -n 1 -- "$file" > "$tmpfile"; then
      rm -f -- "$tmpfile"
      log "ERROR: failed to write temporary file for $file"
      return 4
    fi
    mv -f -- "$tmpfile" "$file"
  done < <(find -- "$TARGET_DIR" -maxdepth 1 -type f -print0)

  log "Cutting files done (kept only first line)."
  return 0
}

# main function:
main() {
  check_target_dir || return $?
  count_files || return $?
  change_permissions_if_needed || return $?
  delete_empty_files || return $?
  cut_files_to_first_line || return $?
  return 0
}

main "$@"
