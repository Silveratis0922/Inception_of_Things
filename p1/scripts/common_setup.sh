#!/bin/sh
set -e

echo "Updating packages list..."
sudo apt-get update -qq -y
echo "Installing curl..."
sudo apt-get install -qq -y curl

echo "Common setup success!"