#!/bin/bash

echo "alias k='sudo kubectl'" >> /home/vagrant/.bashrc
source ~/.bashrc

sudo apt-get update
sudo apt-get upgrade

curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --node-ip=$SERVER_IP

mkdir -p /vagrant/token
cp /var/lib/rancher/k3s/server/node-token /vagrant/token
