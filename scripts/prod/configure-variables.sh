#!/usr/bin/env bash

echo "Do you want to deploy on prod or other ? [p/o]"
read env
if [[ "$env" == "p" ]]
then
  echo "Defining default configuration for production deployement"
  # Adresse des serveurs
  # export BASTION_SERVER="100.67.13.51"
  export BASTION_SERVER=""
  export FRONTEND_SERVER="172.18.0.3"
  export BACKEND_SERVER="172.18.0.3"
  export BASE_SERVER="172.18.0.3"
  # Variables d'environnement spécifique
  # export PGHOST="172.18.0.3"
  # export PGPORT="5432"
  # export PORT="8080"
  # export BACKEND_HOST="localhost:${PORT}"
# elif [[ "$env" == "i" ]]
# then
#   echo "Defining default configuration for integration deployement"
#   # Adresse des serveurs
#   export BASTION_SERVER="sopra-ovh"
#   export FRONTEND_SERVER="front_mncpc_dev"
#   export SERVICES_SERVER="services_mncpc_dev"
#   export USERS_SERVER="services_mncpc_dev"
#   export BASE_SERVER="base_mncpc_dev"
#   # Variables d'environnement spécifique
#   export DB_POSTGRES_HOST_SERVICES="base_mncpc_dev"
#   export DB_POSTGRES_PORT_SERVICES="5432"
#   export DB_POSTGRES_HOST_USERS="base_mncpc_dev"
#   export DB_POSTGRES_PORT_USERS="5432"
#   export MNCPC_USERS_PORT="5552"
#   export MNCPC_SERVICES_PORT="5551"
#   export BACKEND_USERS="services_mncpc_dev:${MNCPC_USERS_PORT}"
#   export BACKEND_SERVICES="services_mncpc_dev:${MNCPC_SERVICES_PORT}"
else
  echo "You should have defined at least the following variables :"
  # Adresse des serveurs
  echo "- BASTION_SERVER"
  echo "- FRONTEND_SERVER"
  echo "- BACKEND_SERVER"
  echo "- BASE_SERVER"
  # Variables d'environnement spécifique
  # echo "- PGHOST"
  # echo "- PGPORT"
  # echo "- PORT"
  # echo "- BACKEND_HOST"

  export SSH_BASTION=""
  if [[ ! -z "${FRONTEND_SERVER}" ]]
  then
    export SSH_FRONTEND_SERVER="ssh ${FRONTEND_SERVER}"
  fi

  if [[ ! -z "${BACKEND_SERVER}" ]]
  then
    export SSH_BACKEND_SERVER="ssh ${BACKEND_SERVER}"
  fi

  if [[ ! -z "${BASE_SERVER}" ]]
  then
    export SSH_BASE_SERVER="ssh ${BASE_SERVER}"
  fi

  if [[ ! -z "${SSH_BASTION}" ]]
  then
    export SCP_BASTION="scp"
  else
    export SCP_BASTION=":"
  fi

  if [[ ! -z "${FRONTEND_SERVER}" ]]
  then
    export SCP_SERVER="scp"
  else
    export SCP_SERVER=":"
  fi

  echo "Press enter if OK or CTRL-C if not to cancel"
  read
fi

if [[ "$env" == "p" || "$env" == "i" ]]
then
  # export SSH_BASTION="ssh -o \"StrictHostKeyChecking no\" ${BASTION_SERVER}"
  export SSH_BASTION=""
  export SSH_FRONTEND_SERVER="${SSH_BASTION} ssh ${FRONTEND_SERVER}"
  export SSH_BACKEND_SERVER="${SSH_BASTION} ssh ${BACKEND_SERVER}"
  export SSH_BASE_SERVER="${SSH_BASTION} ssh ${BASE_SERVER}"

  export SCP_BASTION="cp"
  # export SCP_SERVER="ssh -o \"StrictHostKeyChecking no\" ${BASTION_SERVER} scp"
  export SCP_SERVER="cp"
fi

# echo ""
# echo "You should have specify the variables SERVER_HOSTNAME, LISTEN and SSL_CERTIFICATE to configure the nginx"
# export SERVER_HOSTNAME="${SERVER_HOSTNAME:-localhost}"
# export LISTEN="${LISTEN:-443}"
# export SSL_CERTIFICATE="ssl_certificate /src/certificates/live/${SERVER_HOSTNAME}/fullchain.pem;
# ssl_certificate_key /src/certificates/live/${SERVER_HOSTNAME}/privkey.pem;
# "
# echo SERVER_HOSTNAME=$SERVER_HOSTNAME
# echo LISTEN=$LISTEN
# echo SSL_CERTIFICATE=$SSL_CERTIFICATE

echo ""


# echo "Be sure to have defined required environment variables :"
# echo "- SECRET"
# echo "- PGHOST"
# echo "- PGUSER"
# echo "- PGPASSWORD"
# echo "- DB_USER"
# echo "- DB_PASSWORD"
# echo "- DB_NAME"
# echo "- SERVER_HOSTNAME"
# echo "- ADMIN_USERNAME"
# echo "- ADMIN_EMAIL"
# echo "- ADMIN_PASSWORD"
# echo ""
#
# echo "Press enter if OK or CTRL-C if not to cancel"
# read
