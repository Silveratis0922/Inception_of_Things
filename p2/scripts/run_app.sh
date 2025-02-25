#!/bin/sh
echo "Building container images..."
docker build -t nginx-app1 --build-arg APP_CONTENT=app1.html -f /vagrant/conf/Dockerfile /vagrant/conf
docker build -t nginx-app2 --build-arg APP_CONTENT=app2.html -f /vagrant/conf/Dockerfile /vagrant/conf
docker build -t nginx-app3 --build-arg APP_CONTENT=app3.html -f /vagrant/conf/Dockerfile /vagrant/conf

echo "Exporting Docker images to k3s..."
docker save -o nginx-app1.tar nginx-app1
docker save -o nginx-app2.tar nginx-app2
docker save -o nginx-app3.tar nginx-app3
k3s ctr images import nginx-app1.tar
k3s ctr images import nginx-app2.tar
k3s ctr images import nginx-app3.tar

echo "Applying applications config..."
kubectl apply -f /vagrant/conf/app1.yaml
kubectl apply -f /vagrant/conf/app2.yaml
kubectl apply -f /vagrant/conf/app3.yaml

echo "Applying Ingress (Traefik) config..."
kubectl apply -f /vagrant/conf/ingress.yaml

echo "Applications start success!"