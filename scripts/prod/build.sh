#!/usr/bin/env bash

set -x -e

mkdir deploy || true

# Construction des images
docker-compose -f docker-compose.yml build

# Suppression des images déjà existantes
rm -rf deploy/orchestrator-prod.tar
rm -rf deploy/pypel-default.tar
rm -rf deploy/alpine.tar

# Save des images
docker save orchestrator:prod -o deploy/orchestrator-prod.tar
docker save pypel-default:prod -o deploy/pypel-default.tar
docker save alpine -o deploy/alpine.tar
