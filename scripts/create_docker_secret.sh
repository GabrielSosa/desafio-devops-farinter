#!/bin/bash
set -e

echo "🔐 Generando secreto para GitHub Container Registry (GHCR)..."
# Validar variables de entorno
if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_PAT" ]; then
    echo "❌ Error: Las variables de entorno GITHUB_USER y GITHUB_PAT no están definidas."
    echo "ℹ️  Ejemplo de uso:"
    echo "   export GITHUB_USER=tu_usuario"
    echo "   export GITHUB_PAT=tu_token"
    echo "   ./scripts/create_docker_secret.sh"
    exit 1
fi

USER=$GITHUB_USER
PAT=$GITHUB_PAT

kubectl create secret docker-registry ghcr-secret \
    --docker-server=ghcr.io \
    --docker-username=$USER \
    --docker-password=$PAT \
    --dry-run=client -o yaml | kubectl apply -f -

echo "✅ Secreto 'ghcr-secret' creado/actualizado correctamente."
