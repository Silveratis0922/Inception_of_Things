# p3

## packages to install

docker

k3d
wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash


kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


argocd
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

wil's app
https://hub.docker.com/r/wil42/playground


## commands

cat deployment.yaml | grep v1
cat deployment.yaml | grep v2

curl http://localhost:8888/

sed -i 's/wil42\/playground\:v1/wil42\/playground\:v2/g' deploy.yml

g up "v2" # git add+commit+push

