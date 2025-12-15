.PHONY: setup deploy test clean

setup:
	@echo "🚀 Configurando clúster..."
	./scripts/setup_cluster.sh
	./scripts/setup_extras.sh
	./scripts/setup_secrets.sh

deploy:
	@echo "📦 Desplegando aplicación..."
	kubectl apply -f k8s/argocd-app.yaml

test:
	@echo "🧪 Probando API..."
	@echo "Probando acceso sin autenticación (debe fallar 401/403)..."
	curl -k -I https://localhost/saldo || true
	@echo "\nProbando acceso con API Key (debe ser 200)..."
	curl -k -I -H "apikey: super-secret-key" https://localhost/saldo

clean:
	@echo "🧹 Limpiando..."
	kubectl delete -f k8s/argocd-app.yaml || true
