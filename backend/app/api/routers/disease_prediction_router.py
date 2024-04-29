from fastapi import APIRouter
from app.api.schemas.primary_disease_prediction import (
    Symptom,
    DiseasePredictionResponse,
)
from app.services.gpt_service import primary_disease_prediction

router = APIRouter()


@router.post("/disease_prediction/", response_model=DiseasePredictionResponse)
async def disease_prediction_endpoint(input_data: Symptom):
    return await primary_disease_prediction(input_data)
