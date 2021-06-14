#!/usr/bin/env bash

set -x -e

mkdir deploy || true

# Construction des images
docker-compose -f docker-compose.yml build

# Suppression des images déjà existantes
rm -rf deploy/orchestrator-prod.tar

# Save des images
docker save orchestrator:prod -o deploy/orchestrator-prod.tar
