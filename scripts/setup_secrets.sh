#!/bin/bash
set -e

# ==============================================================================
# Script de Configuración de Secretos para Producción
# ==============================================================================
# Este script centraliza la creación de todos los secretos necesarios para el clúster.
# Lee las credenciales desde un archivo .env o variables de entorno.
# ==============================================================================

echo "🔐 Iniciando gestión de secretos..."

# 1. Cargar variables de entorno
if [ -f .env ]; then
    echo "📄 Cargando variables desde .env..."
    export $(grep -v '^#' .env | xargs)
elif [ -f ../.env ]; then
    echo "📄 Cargando variables desde ../.env..."
    export $(grep -v '^#' ../.env | xargs)
fi

# 2. Validaciones Previas
MISSING_VARS=0
check_var() {
    if [ -z "${!1}" ]; then
        echo "❌ Error: Variable $1 no definida."
        MISSING_VARS=1
    fi
}

check_var "GITHUB_USER"
check_var "GITHUB_PAT"

if [ $MISSING_VARS -eq 1 ]; then
    echo "⚠️  Por favor define las variables requeridas en tu archivo .env o en el entorno."
    exit 1
fi

# Valores por defecto para variables opcionales
API_KEY=${API_KEY:-"super-secret-key"}
REPO_URL="https://github.com/$GITHUB_USER/desafio-devops-farinter.git"

echo "✅ Variables validadas correctamente."

# ==============================================================================
# 3. Secretos de Infraestructura (Docker & Git)
# ==============================================================================

echo "📦 Configurando acceso a GHCR (Docker Registry)..."
kubectl create secret docker-registry ghcr-secret \
    --docker-server=ghcr.io \
    --docker-username=$GITHUB_USER \
    --docker-password=$GITHUB_PAT \
    --dry-run=client -o yaml | kubectl apply -f -

echo "�� Configurando acceso al repositorio Git para ArgoCD..."
# Asegurar que el namespace existe
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

cat <<SECRET | kubectl apply -f -
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
  password: $GITHUB_PAT
  username: $GITHUB_USER
SECRET

# ==============================================================================
# 4. Secretos de Aplicación (Base de Datos & API Gateway)
# ==============================================================================
# 4. Secretos de Aplicación (API Gateway)
# ==============================================================================

echo "🔑 Configurando API Key para Kong..."
    --from-literal=key=$API_KEY \
    --dry-run=client -o yaml | kubectl apply -f -

echo "✨ ¡Todos los secretos han sido configurados exitosamente!"
