#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

curl -sfL https://get.k3s.io | sh -s - agent --server $KUB_URL --token-file /vagrant/token/node-token --flannel-iface=eth1 --node-ip=$WORKER_IP