#!/bin/bash
set -e

# Apply YAML files
echo "Deployment of YAML files..."


# Récupère le dossier parent du script (c'est-à-dire le dossier p3)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Appliquer les fichiers YAML
kubectl apply -f "$BASE_DIR/conf/deployment.yaml"
kubectl apply -f "$BASE_DIR/conf/service.yaml"
kubectl apply -f "$BASE_DIR/conf/argo-application.yaml"

echo "Everything is setup! Success!"