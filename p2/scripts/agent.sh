#!/bin/bash

curl -sfL https://get.k3s.io | sh -s - agent --server https://192.168.56.110:6443 --token-file /vagrant/token/node-token --flannel-iface=eth1 --node-ip=192.168.56.111