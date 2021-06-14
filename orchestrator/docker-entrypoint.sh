#!/usr/bin/env bash

# Récupération des fichiers de configuration définissant les différents monitors à mettre en place
readarray -t CONFIG_FILES < <(ls /config/*.conf)

# TODO Add a trigger inside postgres to trigger NOTIFY indexes
# TODO use /pg_listen/pg_listen to listen for indexes configuration changes

for config in "${CONFIG_FILES[@]}"
do
  bash /run.sh "$config" &
done

wait
