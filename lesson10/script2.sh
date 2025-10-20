#!/bin/bash

DIR="$HOME/myfolder"

if [ ! -d "$DIR" ]; then
  echo "folder $DIR not found."
  exit 0
fi

# count files:
count=$(find "$DIR" -maxdepth 1 -type f | wc -l)
echo "files in  $DIR: $count"

# change privileges:
file2="$DIR/file2.txt"
if [ -f "$file2" ]; then
  perms=$(stat -c "%a" "$file2" 2>/dev/null || echo "")
  if [ "$perms" = "777" ]; then
    chmod 664 "$file2" 2>/dev/null || true
    echo "privileges  $file2 changed  from 777 to  664"
  else
    echo "privileges  $file2: $perms "
  fi
fi

# delete empty files:
empty_list=$(find "$DIR" -maxdepth 1 -type f -empty -print)
if [ -n "$empty_list" ]; then
  echo "deleting empty files:"
  echo "$empty_list"
  find "$DIR" -maxdepth 1 -type f -empty -delete
else
  echo "empty files not found"
fi

# leave only first line in files:
while IFS= read -r -d '' f; do
  first_line=$(sed -n '1p' "$f" 2>/dev/null || true)
  if [ -z "$first_line" ] && [ ! -s "$f" ]; then
    continue
  fi
  printf '%s\n' "$first_line" > "$f.tmp" && mv -f "$f.tmp" "$f"
done < <(find "$DIR" -maxdepth 1 -type f -print0)
echo "cutting files done (exept first line)"
