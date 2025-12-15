# Etapa 1: Constructor (Builder)
FROM python:3.11-slim as builder

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Etapa 2: Ejecución (Runtime)
FROM python:3.11-slim

WORKDIR /app

# Crear un usuario no-root
RUN groupadd -r appuser && useradd -r -g appuser -u 1001 appuser

# Copiar paquetes instalados desde el builder
COPY --from=builder /root/.local /home/appuser/.local
COPY app/ .

# Actualizar PATH
ENV PATH=/home/appuser/.local/bin:$PATH

# Cambiar al usuario no-root
USER appuser

# Exponer puerto
EXPOSE 8000

# Ejecutar aplicación
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
