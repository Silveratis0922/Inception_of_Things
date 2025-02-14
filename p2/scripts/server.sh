#!/bin/bash

curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --node-ip=192.168.56.110

mkdir -p /vagrant/token
cp /var/lib/rancher/k3s/server/node-token /vagrant/token

sudo kubectl create -f /vagrant/apps/app1.yaml
sudo kubectl create -f /vagrant/apps/app2.yaml
sudo kubectl create -f /vagrant/apps/app3.yaml
sudo kubectl create -f /vagrant/service/app1.yaml
sudo kubectl create -f /vagrant/service/app2.yaml
sudo kubectl create -f /vagrant/service/app3.yaml
sudo kubectl apply -f /vagrant/ingress.yaml
