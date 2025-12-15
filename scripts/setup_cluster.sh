#!/bin/bash
set -e

echo "🚀 Iniciando configuración del clúster..."

# 1. Instalar ArgoCD
echo "🐙 Instalando ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Instalar Kong (DB-less)
echo "🦍 Instalando Kong Ingress Controller (DB-less)..."
kubectl create namespace kong --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/master/deploy/single/all-in-one-dbless.yaml

echo "⏳ Esperando a que los componentes estén listos..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd || echo "⚠️ ArgoCD tardando en iniciar..."
kubectl wait --for=condition=available --timeout=300s deployment/ingress-kong -n kong || echo "⚠️ Kong tardando en iniciar..."

echo "✅ Clúster base configurado."
