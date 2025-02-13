#!/bin/sh
set -e

echo "Installing k3s in agent mode..."
curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${K3S_TOKEN} sh -

echo "k3s agent installation success!"