#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -qq
sudo apt-get upgrade -yqq


# sudo apt-get install -yqq curl wget vim net-tools git make apt-transport-https ca-certificates software-properties-common gpg gnupg2 lsb-release

# List of packages to be installed
packages=(
  curl
  wget
  vim
  net-tools
  git
  make
  apt-transport-https
  ca-certificates
  software-properties-common
  gpg
  gnupg2
  lsb-release
)

# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
  if ! dpkg-query -W -f='${Status}' $package 2>/dev/null | grep -q "ok installed"; then
    echo "\033[38;5;214mInstalling $package...\033[0m"
    sudo apt-get install -yqq $package
  else
    echo "\033[38;5;214m$package is already installed.\033[0m"
  fi
done

# packages for GUI
sudo apt-get install -yqq xfce4 xfce4-goodies xorg dbus-x11
sudo apt-get install -yqq firefox-esr


# Check and install Docker
if docker -v > /dev/null 2>&1; then
  echo -e "\033[38;5;214mDocker is already installed\033[0m"
  docker -v
else
  echo -e "\033[38;5;214mInstalling Docker\033[0m"
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
  echo -e "\033[38;5;214mk3d is already installed\033[0m"
  k3d --version
else
  echo -e "\033[38;5;214mInstalling k3d\033[0m"
  wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi


# Check and install kubectl
if kubectl version > /dev/null 2>&1; then
  echo -e "\033[38;5;214mkubectl is already installed\033[0m"
  kubectl version
else
  echo -e "\033[38;5;214mInstalling kubectl\033[0m"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubectl
fi

echo "alias k='sudo kubectl'" >> /home/vagrant/.bashrc
echo "source <(k3d completion bash)" >> ~/.bashrc
source ~/.bashrc

# activate GUI
echo "VBoxClient-all" >> ~/.xsessionrc
sudo systemctl set-default graphical.target
# sudo reboot

