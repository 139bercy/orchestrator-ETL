#!/usr/bin/env bash

set -e

mkdir -p /app/conf 2> /dev/null || true

# Check path_to_data
if [[ ! -v path_to_data ]]
then
  echo "La variable path_to_data n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  path_to_data=$(cat /app/conf/config.json | jq '.path_to_data' | sed 's/"//g')
fi
# Check kibana_info
if [[ ! -v kibana_info ]]
then
  echo "La variable kibana_info n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  kibana_info=$(cat /app/conf/config.json | jq '.kibana_info' | sed 's/"//g')
fi
# Check elasticsearch_host
if [[ ! -v elasticsearch_scheme ]]
then
  echo "La variable elasticsearch_scheme n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  elasticsearch_scheme=$(cat /app/conf/config.json | jq '.scheme' | sed 's/"//g')
fi
# Check elasticsearch_host
if [[ ! -v elasticsearch_host ]]
then
  echo "TOTO${elasticsearch_host}TITI"
  echo "La variable elasticsearch_host n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  elasticsearch_host=$(cat /app/conf/config.json | jq '.host' | sed 's/"//g')
fi
# Check elasticsearch_user
if [[ ! -v elasticsearch_user ]]
then
  echo "La variable elasticsearch_user n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  elasticsearch_user=$(cat /app/conf/config.json | jq '.user' | sed 's/"//g')
fi
# Check elasticsearch_password
if [[ ! -v elasticsearch_password ]]
then
  echo "La variable elasticsearch_password n'est pas définie. La configuration par défaut, si elle existe, sera utilisée"
  elasticsearch_password=$(cat /app/conf/config.json | jq '.pwd' | sed 's/"//g')
fi

echo "Génération (ou surcharge) du fichier /app/conf/config.json à partir des variables d'environnement ou du fichier déjà existant"
if [[ ! -a "/app/conf/config.json" ]]
then
  echo "Génération ..."
cat <<EOF > /app/conf/config.json
{
	"path_to_data": "${path_to_data}",
	"kibana_info": "${kibana_info}",
  "host": "${elasticsearch_host:-localhost}",
	"user": "${elasticsearch_user:-elastic}",
	"pwd": "${elasticsearch_password:-elastic}",
  "scheme": "${elasticsearch_scheme:-https}"
}
EOF
else
  echo "surcharge ..."
  sed -e 's|"path_to_data": ".*"|"path_to_data": "'${path_to_data}'"|g' \
  -e 's/"kibana_info": ".*"/"kibana_info": "'${kibana_info}'"/g' \
  -e 's/"host": ".*"/"host": "'${elasticsearch_host:-localhost}'"/g' \
  -e 's/"scheme": ".*"/"scheme": "'${elasticsearch_scheme:-https}'"/g' \
  -e 's/"user": ".*"/"user": "'${elasticsearch_user:-elastic}'"/g' \
  -e 's/"pwd": ".*"/"pwd": "'${elasticsearch_password:-elastic}'"/g' \
  -i /app/conf/config.json
fi

if [[ "$DEBUG" == "true" ]]
then
  cat /app/conf/config.json
fi

# run the python main.py file and display the logs
#python3 /app/main.py $@
echo "python3 /app/main.py $@"
python3 /app/main.py $@
cat /app/logging/*.log
