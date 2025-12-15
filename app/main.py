from fastapi import FastAPI
import os

app = FastAPI()

@app.get("/saldo")
def get_saldo():
    return {
        "saldo": 123.45,
        "moneda": "USD",
        "hostname": os.getenv("HOSTNAME", "unknown")
    }

@app.get("/health")
def health_check():
    return {"status": "ok"}
