#!/usr/bin/env bash

date=$(date +%s)
# Démarrage du service d'orchestration
command="
set -x

docker volume create orchestrator_config
docker volume create orchestrator_scripts
#  Devrait déjà exister si data-upload a été installé
docker volume create data_upload_data

# Arrêt des containers déjà existants sur la plate-forme
docker ps -q --filter \"name=orchestrator-service-\" | xargs --no-run-if-empty docker stop

docker run -d --name orchestrator-service-${date} \
  --restart=unless-stopped \
  -v data_upload_data:/data \
  -v orchestrator_config:/config \
  -v orchestrator_scripts:/scripts \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /etc/localtime:/etc/localtime \
  -e DATA_VOLUME=\"data_upload_data\" \
  orchestrator:prod
  -e DATA_VOLUME: \"data_upload_data\" \
  data-upload-backend:prod

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
