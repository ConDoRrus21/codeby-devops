#!/bin/bash

DIR="$HOME/myfolder"
mkdir -p "$DIR"

# file1:
printf '%s\n%s\n' "Привет!" "$(date '+%Y-%m-%d %H:%M:%S')" > "$DIR/file1.txt"

# file2:
: > "$DIR/file2.txt"
chmod 0777 "$DIR/file2.txt" 2>/dev/null || true

# file3:
rand=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c20 || echo "####################")
printf '%s\n' "$rand" > "$DIR/file3.txt"

# file4 and file5:
: > "$DIR/file4.txt"
: > "$DIR/file5.txt"
