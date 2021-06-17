#!/usr/bin/env bash


# Nettoyage du service d'orhestration
command="
set -x

docker ps -a --filter \"name=orchestrator-service-\" --filter \"status=exited\" --format \"{{ .Names }}\" | xargs --no-run-if-empty docker rm

set +x
"

if [[ -z $SSH_BACKEND_SERVER ]]
then
  eval "$command"
else
  eval $SSH_BACKEND_SERVER <<EOF
    $command
EOF
fi
