#!/bin/bash
set -e

NAMESPACE_ARGOCD="argocd"
NAMESPACE_DEV="dev"

# Create k3d cluster
echo -e "\033[38;5;214mCreating k3d cluster...\033[0m"
k3d cluster create mycluster --servers 1

# Make sure the kubeconfig file is set up correctly
export KUBECONFIG=$(k3d kubeconfig write mycluster) ##

# Install ArgoCD
echo -e "\033[38;5;214mArgoCD installing...\033[0m"
kubectl create namespace $NAMESPACE_ARGOCD
kubectl apply -n $NAMESPACE_ARGOCD -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD deployment
echo -e "\033[38;5;214mWaiting for ArgoCD pods...\033[0m"
kubectl wait --for=condition=Available --timeout=600s deployment -l app.kubernetes.io/name=argocd-server -n $NAMESPACE_ARGOCD

# Get ArgoCD password
echo -e "\033[38;5;214mGetting ArgoCD password...\033[0m"
ARGOCD_PWD=$(kubectl -n $NAMESPACE_ARGOCD get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "\033[38;5;214mArgoCD password : $ARGOCD_PWD\033[0m"

# Config ArgoCD CLI
if ! command -v argocd &> /dev/null
then
    echo -e "\033[38;5;214mInstalling ArgoCD CLI...\033[0m"
    curl -sSL -o argocd-linux-amd64 "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
    chmod +x argocd-linux-amd64
    sudo mv argocd-linux-amd64 /usr/local/bin/argocd
fi

# Connect to Argo CD and change default password
echo -e "\033[38;5;214mConnection to Argo CD...\033[0m"
kubectl port-forward svc/argocd-server -n $NAMESPACE_ARGOCD 8080:443 &
sleep 2
argocd login localhost:8080 --username admin --password $ARGOCD_PWD --insecure
argocd account update-password --account admin --current-password $ARGOCD_PWD --new-password "admin123"

# Create the dev namespace
kubectl create namespace $NAMESPACE_DEV

# Apply YAML files
echo -e "\033[38;5;214mDeployment of YAML files...\033[0m"
kubectl apply -f ../confs/deployment.yaml
kubectl apply -f ../confs/service.yaml
kubectl apply -f ../confs/argo-application.yaml

# kubectl port-forward svc/wil-playground-service -n dev 8888:8888


echo -e "\033[38;5;214mEverything is setup! Success!\033[0m"



# sudo reboot