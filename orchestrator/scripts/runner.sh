#!/usr/bin/env bash

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
echo "docker run --rm --network=host --env-file \"$CONFIG\" -v \"$DATA_VOLUME\":/data \"$DOCKER_IMAGE\" $PARAMETERS"
cat "$CONFIG"
docker run --rm --network=host --env-file "$CONFIG" -v "$DATA_VOLUME":/data "$DOCKER_IMAGE" $PARAMETERS
echo $files
for file in $files
do
  echo "$file"
  rm "$file"
done
