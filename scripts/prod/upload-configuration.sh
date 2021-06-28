#!/usr/bin/env bash

# Copie des images par SSH vers le bastion
# eval $SSH_BASTION mkdir -p deploy/jwt-keys 2> /dev/null || true
# eval $SSH_BACKEND_SERVER mkdir -p deploy/jwt-keys 2> /dev/null || true
# eval $SSH_FRONTEND_SERVER mkdir -p deploy/jwt-keys 2> /dev/null || true
# eval $SCP_BASTION deploy $BASTION_SERVER

# copie des images sur chacun des serveurs
eval $SCP_SERVER ./deploy/orchestrator.tar $BACKEND_SERVER:./deploy/
eval $SCP_SERVER ./deploy/pypel-default.tar $BACKEND_SERVER:./deploy/
eval $SCP_SERVER ./deploy/data-360-prod.tar $BACKEND_SERVER:./deploy/
eval $SCP_SERVER ./deploy/busybox.tar $BACKEND_SERVER:./deploy/
# eval $SCP_SERVER ./deploy/data-upload-backend.tar $BACKEND_SERVER:./deploy/
# eval $SCP_SERVER ./deploy/data-upload-nginx-frontend.tar $FRONTEND_SERVER:./deploy/

# Copie des certificats et clé de chiffrement
# eval $SCP_SERVER -r ./deploy/jwt-keys/* $BACKEND_SERVER:./deploy/jwt-keys/
# eval $SCP_SERVER -r ./deploy/jwt-keys/* $SERVICES_SERVER:./deploy/jwt-keys/
# eval $SCP_SERVER -r ./deploy/jwt-keys/* $FRONTEND_SERVER:./deploy/jwt-keys/

# Load des images
eval $SSH_BACKEND_SERVER docker load -i ./deploy/orchestrator.tar
eval $SSH_BACKEND_SERVER docker load -i ./deploy/pypel-default.tar
eval $SSH_BACKEND_SERVER docker load -i ./deploy/data-360-prod.tar
eval $SSH_BACKEND_SERVER docker load -i ./deploy/busybox.tar
# eval $SSH_BACKEND_SERVER docker load -i ./deploy/data-upload-backend.tar
# eval $SSH_FRONTEND_SERVER docker load -i ./deploy/data-upload-nginx-frontend.tar


# Création des volumes sur chaque serveurs
eval $SSH_BASE_SERVER docker volume create orchestrator_config
eval $SSH_BACKEND_SERVER docker volume create orchestrator_scripts
#  Devrait déjà exister si data-upload a été installé
eval $SSH_FRONTEND_SERVER docker volume create data_upload_data

# Copie des certificats et des clés de chiffrement dans le volume correspondant sur les différents serveurs
date_container="$(date +%s)"
eval $SSH_BACKEND_SERVER docker run -d --name dummy-${date_container} -v orchestrator_config:/config busybox
eval $SSH_BACKEND_SERVER docker cp ./deploy/config/ dummy-${date_container}:/config
eval $SSH_BACKEND_SERVER docker stop dummy-${date_container}
eval $SSH_BACKEND_SERVER docker rm dummy-${date_container}

eval $SSH_BACKEND_SERVER docker run -d --name dummy-${date_container} -v orchestrator_scripts:/scripts busybox
eval $SSH_BACKEND_SERVER docker cp ./deploy/scripts/ dummy-${date_container}:/scripts
eval $SSH_BACKEND_SERVER docker stop dummy-${date_container}
eval $SSH_BACKEND_SERVER docker rm dummy-${date_container}
