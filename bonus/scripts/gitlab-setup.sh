#!/bin/bash

NAMESPACE_GITLAB="gitlab"

# Install Helm (si ce n'est pas déjà fait)
if ! command -v helm &> /dev/null
then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Ajouter le repo Helm GitLab
echo "Adding GitLab Helm repo..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Installation de GitLab en mode minimal
echo "Installing Gitlab..."
helm upgrade --install gitlab gitlab/gitlab \
  --namespace $NAMESPACE_GITLAB \
  --set global.hosts.domain="local" \
  --set gitlab.webservice.serviceType=LoadBalancer \
  --set certmanager-issuer.email="your-email@example.com" \
  --set gitlab-runner.install=false \
  --set minio.install=false \
  --set prometheus.install=false \
  --set global.grafana.enabled=false \
  --set global.mailroom.enabled=false


# Attendre que les pods soient prêts
echo "Waiting for GitLab pods..."
kubectl wait --for=condition=Available --timeout=1200s deployment -n $NAMESPACE_GITLAB -l app=webservice

# Récupérer le mot de passe admin de GitLab
echo "Getting GitLab admin password..."
GITLAB_PWD=$(kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 --decode)
echo "GitLab admin password: $GITLAB_PWD"

# Exposer GitLab en local (port-forward)
kubectl port-forward --namespace gitlab svc/gitlab-webservice-default 8081:8181 &
