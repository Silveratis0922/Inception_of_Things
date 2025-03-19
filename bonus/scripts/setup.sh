#!/bin/bash
set -e

NAMESPACE_ARGOCD="argocd"
NAMESPACE_DEV="dev"
NAMESPACE_GITLAB="gitlab"

# Create k3d cluster
echo "Creating k3d cluster..."
k3d cluster create mycluster --servers 1

# Create namespaces
kubectl create namespace $NAMESPACE_DEV
kubectl create namespace $NAMESPACE_ARGOCD
kubectl create namespace $NAMESPACE_GITLAB

# Install ArgoCD
echo "ArgoCD installing..."
kubectl apply -n $NAMESPACE_ARGOCD -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD deployment
echo "Waiting for ArgoCD pods..."
kubectl wait --for=condition=Available --timeout=600s deployment -l app.kubernetes.io/name=argocd-server -n $NAMESPACE_ARGOCD

# Get ArgoCD password
echo "Getting ArgoCD password..."
ARGOCD_PWD=$(kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD password : $ARGOCD_PWD"

# Config ArgoCD CLI
if ! command -v argocd &> /dev/null
then
    echo "Installing ArgoCD CLI..."
    curl -sSL -o argocd-linux-amd64 "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
    chmod +x argocd-linux-amd64
    sudo mv argocd-linux-amd64 /usr/local/bin/argocd
fi

# Connect to Argo CD and change default password
echo "Connection to Argo CD..."
kubectl port-forward svc/argocd-server --address 0.0.0.0 -n $NAMESPACE_ARGOCD 8080:443 &
sleep 2
argocd login localhost:8080 --username admin --password $ARGOCD_PWD --insecure
argocd account update-password --account admin --current-password $ARGOCD_PWD --new-password "admin123"
