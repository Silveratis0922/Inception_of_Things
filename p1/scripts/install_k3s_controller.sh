#!/bin/sh
set -e

echo "Installing k3s in controller mode..."
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

echo "Sharing token for the agents..."
mkdir -p /vagrant/shared
cat /var/lib/rancher/k3s/server/node-token > ${SHARED_DIR}/${K3S_TOKEN}

echo "k3s controller installation success!"