from fastapi.testclient import TestClient
from .main import app

client = TestClient(app)

def test_read_saldo():
    response = client.get("/saldo")
    assert response.status_code == 200
    assert "saldo" in response.json()
    assert "moneda" in response.json()
    assert response.json()["saldo"] == 123.45

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
