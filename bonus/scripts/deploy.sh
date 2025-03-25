#!/bin/bash
set -e

# Apply YAML files
echo "Deployment of YAML files..."


# Récupère le dossier parent du script (c'est-à-dire le dossier p3)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Appliquer les fichiers YAML
kubectl apply -f "$BASE_DIR/confs/deployment.yaml"
kubectl apply -f "$BASE_DIR/confs/service.yaml"
kubectl apply -f "$BASE_DIR/confs/argo-application.yaml"

echo "Everything is setup! Success!"