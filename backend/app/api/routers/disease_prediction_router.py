from fastapi import APIRouter
from app.api.schemas.primary_disease_prediction import (
    User_Symptom_Input,
    PrimaryDiseasePredictionResponse,
)
from app.api.schemas.secondary_disease_prediction import SecondaryDiseasePredictionRequest
from app.services.gpt_service import *

router = APIRouter()


@router.post("/primary_disease_prediction/", response_model=PrimaryDiseasePredictionResponse)
async def disease_prediction_endpoint(input_data: User_Symptom_Input):
    return await primary_disease_prediction(input_data)

@router.post("/secondary_disease_prediction/")
async def secondary_disease_prediction_endpoint(input_data: SecondaryDiseasePredictionRequest):
    return await secondary_disease_prediction(input_data)