import pytest
from app.services.gpt_service import disease_prediction
from app.api.schemas.disease_prediction_schema import SymptomInput
from httpx import AsyncClient

from app.main import app


@pytest.mark.asyncio
async def test_analyze_symptoms():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post(
            "/disease_prediction/",
            json={"symptoms": "두통(headache), 열(fever)"},
        )
        assert response.status_code == 200
