#!/bin/bash

echo "alias k='sudo kubectl'" >> /home/vagrant/.bashrc
source ~/.bashrc

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -qq
sudo apt-get upgrade -yqq
sudo apt-get install -yqq curl wget vim net-tools git make apt-transport-https ca-certificates software-properties-common gpg gnupg2 lsb-release



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


