#!/usr/bin/env bash


# Nettoyage du service d'orchestration
command="
set -x

docker ps -a --filter \"name=orchestrator-service-\" --format \"{{ .Names}}\" | sort -u | tail -1 | xargs --no-run-if-empty docker stop
docker ps -a --filter \"name=orchestrator-service-\" --format \"{{ .Names}}\" | sort -u | tail -2 | head -1 | xargs --no-run-if-empty docker start

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
