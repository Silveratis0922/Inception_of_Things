#!/bin/bash

echo "alias k='sudo kubectl'" >> /home/vagrant/.bashrc
source ~/.bashrc

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y curl vim net-tools

curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --node-ip=$SERVER_IP

mkdir -p /vagrant/token
cp /var/lib/rancher/k3s/server/node-token /vagrant/token

echo -e "192.168.56.110 app1.com" | sudo tee -a /etc/hosts
echo -e "192.168.56.110 app2.com" | sudo tee -a /etc/hosts
echo -e "192.168.56.110 app3.com" | sudo tee -a /etc/hosts

# sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

sudo kubectl apply -f /vagrant/confs/namespace.yaml
sudo kubectl apply -f /vagrant/confs/deployment.yaml
sudo kubectl apply -f /vagrant/confs/service.yaml
sudo kubectl apply -f /vagrant/confs/ingress.yaml

