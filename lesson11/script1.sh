#!/usr/bin/env bash
# Exit codes:
#   0 — success
#   1 — mkdir failed
#   2 — write file1 failed
#   3 — create file2 failed
#   4 — create file3 failed
#   5 — create empty files failed

set -euo pipefail
IFS=$'\n\t'

# constants:
TARGET_DIR="${HOME}/myfolder"
FILE1="${TARGET_DIR}/file1.txt"
FILE2="${TARGET_DIR}/file2.txt"
FILE3="${TARGET_DIR}/file3.txt"
FILE4="${TARGET_DIR}/file4.txt"
FILE5="${TARGET_DIR}/file5.txt"
DATE_FORMAT='%Y-%m-%d %H:%M:%S'
RANDOM_CHARS_LEN=20

# helpers:
log() { printf '%s\n' "$*"; }

# create folder:
create_target_dir() {
  if ! mkdir -p -- "$TARGET_DIR"; then
    log "ERROR: cannot create directory $TARGET_DIR"
    return 1
  fi
  return 0
}

# FILE1: hello + current date/time
write_file1() {
  if ! printf '%s\n%s\n' "Привет!" "$(date "+$DATE_FORMAT")" > "$FILE1"; then
    log "ERROR: failed to write $FILE1"
    return 2
  fi
  return 0
}

# FILE2: empty file with permissions 0777
create_file2() {
  if ! : > "$FILE2"; then
    log "ERROR: failed to create $FILE2"
    return 3
  fi
  # ignore chmod error but try to set
  chmod 0777 -- "$FILE2" 2>/dev/null || true
  return 0
}

# FILE3: random string
create_file3() {
  local rand
  rand=$(tr -dc 'A-Za-z0-9' </dev/urandom 2>/dev/null | head -c"$RANDOM_CHARS_LEN" || true)
  if [ -z "$rand" ]; then
    rand=$(printf '%*s' "$RANDOM_CHARS_LEN" '' | tr ' ' '#')
  fi
  if ! printf '%s\n' "$rand" > "$FILE3"; then
    log "ERROR: failed to write $FILE3"
    return 4
  fi
  return 0
}

# FILE4 and FILE5: empty files
create_file4_and_5() {
  if ! : > "$FILE4" || ! : > "$FILE5"; then
    log "ERROR: failed to create $FILE4 or $FILE5"
    return 5
  fi
  return 0
}

# main function:
main() {
  create_target_dir || return $?
  write_file1 || return $?
  create_file2 || return $?
  create_file3 || return $?
  create_file4_and_5 || return $?
  log "All files created in $TARGET_DIR"
  return 0
}

main "$@"
