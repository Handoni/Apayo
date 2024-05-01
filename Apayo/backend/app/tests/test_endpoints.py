from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_disease_prediction_endpoint():
    response = client.post(
        "/disease_prediction/", json={"symptoms": "headache and fever"}
    )
    assert response.status_code == 200
