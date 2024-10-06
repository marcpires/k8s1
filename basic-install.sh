#!/bin/bash

# Variables
K3S_VERSION="v1.26.1+k3s1"
NAMESPACE="argocd"
HELM_REPO="https://charts.bitnami.com/bitnami"
CHART_NAME="rabbitmq"
CHART_VERSION="12.0.0"  # You can adjust this based on your needs
HELM_RELEASE_NAME="rabbitmq-release"
HELM_VALUES=""  # Optional, path to custom Helm values file

# Install k3s
echo "Installing k3s..."
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$K3S_VERSION sh -

# Check if k3s is running
k3s kubectl get nodes
if [ $? -ne 0 ]; then
    echo "Failed to install k3s." >&2
    exit 1
else
    echo "k3s successfully installed."
fi

# Install ArgoCD
echo "Installing ArgoCD..."

# Create the ArgoCD namespace
k3s kubectl create namespace $NAMESPACE

# Install ArgoCD using the provided manifests
k3s kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
k3s kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n $NAMESPACE

# Check if ArgoCD pods are running
k3s kubectl get pods -n $NAMESPACE
if [ $? -ne 0 ]; then
    echo "Failed to install ArgoCD." >&2
    exit 1
else
    echo "ArgoCD successfully installed."
fi

# Get the initial ArgoCD admin password
echo "ArgoCD Admin password:"
k3s kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Install ArgoCD ApplicationSet controller
echo "Installing ArgoCD ApplicationSet controller..."
k3s kubectl apply -n $NAMESPACE -f https://raw.githubusercontent.com/argoproj-labs/applicationset/v0.4.1/manifests/install.yaml
