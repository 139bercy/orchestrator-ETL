#!/usr/bin/env bash

CONFIG="$1"

WATCH_DIR="$(cat $CONFIG | grep "WATCH_DIR" | cut -d'=' -f2)"
COMMAND="$(cat $CONFIG | grep "COMMAND" | cut -d'=' -f2)"
echo "Creating monitor for $(basename $CONFIG) by watching \"$WATCH_DIR\""

while [[ 1 ]]
do
  mkdir -p "$WATCH_DIR"
  inotifywait $WATCH_DIR -r -m -e close_write |
    while read path action file; do
      echo "Starting the command for '$file' in '$path'"
      bash "$COMMAND" "$path" "$action" "$file" $CONFIG
      sleep 1s
    done
  echo "Waiting some time to provide stabilization"
  sleep 10s
done
