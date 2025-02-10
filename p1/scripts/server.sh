#!/bin/bash

curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --node-ip=192.168.56.110

mkdir -p /vagrant/token
cp /var/lib/rancher/k3s/server/node-token /vagrant/token