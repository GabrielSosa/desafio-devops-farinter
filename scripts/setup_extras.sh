#!/bin/bash
set -e

echo "🛠️  Instalando componentes extra..."

# Instalar Cert-Manager (para TLS)
echo "🔒 Instalando Cert-Manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

echo "⏳ Esperando a que Cert-Manager esté listo..."
kubectl wait --for=condition=available --timeout=300s deployment/cert-manager-webhook -n cert-manager || echo "⚠️ Cert-Manager tardando en iniciar..."

echo "✅ Extras instalados."
