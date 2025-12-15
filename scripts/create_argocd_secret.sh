#!/bin/bash
set -e

echo "🔐 Configurando credenciales de Git en ArgoCD..."

# Validar variables de entorno
if [ -z "$GITHUB_USER" ] || [ -z "$GITHUB_PAT" ]; then
    echo "❌ Error: Las variables de entorno GITHUB_USER y GITHUB_PAT no están definidas."
    echo "ℹ️  Ejemplo de uso:"
    echo "   export GITHUB_USER=tu_usuario"
    echo "   export GITHUB_PAT=tu_token"
    echo "   ./scripts/create_argocd_secret.sh"
    exit 1
fi

USER=$GITHUB_USER
PAT=$GITHUB_PAT
REPO_URL="https://github.com/$USER/desafio-devops-farinter.git"

# Crear el secreto con las etiquetas necesarias para que ArgoCD lo reconozca
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: $REPO_URL
  password: $PAT
  username: $USER
EOF

echo "✅ Credenciales de Git actualizadas en ArgoCD."
