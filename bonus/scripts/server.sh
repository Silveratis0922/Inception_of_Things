#!/bin/bash

echo "alias k='sudo kubectl'" >> /home/vagrant/.bashrc
echo "source <(k3d completion bash)" >> ~/.bashrc
source ~/.bashrc

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -qq
sudo apt-get upgrade -yqq
sudo apt-get install -yqq curl wget vim net-tools git make apt-transport-https ca-certificates software-properties-common gpg gnupg2 lsb-release

# access gitlab instance at : http://gitlab.iot.local
# if not working, try setting that on host machine
echo -e "192.168.56.110 gitlab.iot.local" | sudo tee -a /etc/hosts


# Check and install Docker
if docker -v > /dev/null 2>&1; then
  echo "Docker is already installed"
  docker -v
else
  echo "Installing Docker"
  # remove current docker to avoid conflict
  for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
  # Add Docker's official GPG key:
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  
  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  #install packages
  sudo apt-get install -yqq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo usermod -aG docker vagrant
  newgrp docker
fi


# Check and install k3d
if k3d --version > /dev/null 2>&1; then
  echo "k3d is already installed"
  k3d --version
else
  echo "Installing k3d"
  wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi


# Check and install kubectl
if kubectl version > /dev/null 2>&1; then
  echo "kubectl is already installed"
  kubectl version
else
  echo "Installing kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubectl
fi

sudo kubectl apply -f /vagrant/confs/namespace.yaml



# Check and install Helm
if helm version > /dev/null 2>&1; then
  echo "Helm is already installed"
  helm version --short
else
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
  sudo apt-get install -y apt-transport-https
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update
  sudo apt-get install helm
fi

# Check and install Gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=iot.local \
  --set global.hosts.externalIP=0.0.0.0 \
  --namespace gitlab --create-namespace
#   --set global.ingress.class=traefik

# maybe only need one
helm status gitlab
kubectl get all -n gitlab

# # next steps :
# kubectl get ingress -n gitlab
# # in browser:
# http://gitlab.iot.local
# # troubleshooting:
#  Troubleshooting
# 🔸 If the site doesn’t load:

#     Check if the Ingress is routing traffic correctly:

# kubectl describe ingress gitlab -n gitlab

# Ensure Traefik is running:

# kubectl get pods -n kube-system | grep traefik

# Restart Traefik (if needed):

# kubectl rollout restart deployment traefik -n kube-system
