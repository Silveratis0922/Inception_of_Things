#!/bin/bash

# Delete all k3d clusters
echo -e "\033[38;5;214mDeleting all k3d clusters...\033[0m"
for cluster in $(k3d cluster list -o json | jq -r '.[].name'); do
  k3d cluster delete $cluster
done

# Delete all Kubernetes namespaces (except default, kube-system, kube-public)
echo -e "\033[38;5;214mDeleting all Kubernetes namespaces...\033[0m"
for namespace in $(kubectl get namespaces -o jsonpath="{.items[*].metadata.name}"); do
  if [[ "$namespace" != "default" && "$namespace" != "kube-system" && "$namespace" != "kube-public" ]]; then
    kubectl delete namespace $namespace
  fi
done

# Optionally, delete all resources in the default namespace
echo -e "\033[38;5;214mDeleting all resources in the default namespace...\033[0m"
kubectl delete all --all -n default

echo -e "\033[38;5;214mAll clusters, namespaces, and resources have been deleted.\033[0m"

# #  To check that all was deleted:
# k3d cluster list
# kubectl get all