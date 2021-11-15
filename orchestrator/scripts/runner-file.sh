#!/usr/bin/env bash

#
# Traitement du fichier en utilisant des commandes provenant d'image Docker custom implémentant Pypel
#
path="$1"
action="$2"
file="$3"
CONFIG="$4"

if [[ ! -z "$CONFIG" ]]
then
  source $CONFIG
fi

set -e
cd "$path"
IFS=$(echo -en "\n\b")
files=$(ls -1)

echo "$CONFIG"
cat "$CONFIG"

echo $files
for file in $files
do
  echo "$file"

  echo "docker run --rm --network=host $DOCKER_OPTIONS --env-file \"$CONFIG\" -v \"$DATA_VOLUME\":/data \"$DOCKER_IMAGE\" $PARAMETERS"
  docker run --rm --network=host --env-file "$CONFIG" -v "$DATA_VOLUME":/data "$DOCKER_IMAGE" $PARAMETERS

  if [[ -z ${BACKUP_FILE} && "${BACKUP_FILE}" == true ]]
  then
    mkdir -p "/data/backup/$(echo $WATCH_DIR | sed 's|/data||')"
    mv "$file" "/data/backup/$(echo $WATCH_DIR | sed 's|/data||')/"
  fi
  if [[ -z ${REMOVE_FILE} && "${REMOVE_FILE}" == true ]]
  then
    rm "$file"
  fi
done
