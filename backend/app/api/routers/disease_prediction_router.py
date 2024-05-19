from fastapi import APIRouter
from app.api.schemas.primary_disease_prediction import (
    UserSymptomInput,
    PrimaryDiseasePredictionResponse,
)
from app.api.schemas.secondary_disease_prediction import (
    UserQuestionResponse,
    PredictedDisease,
)
from app.services.gpt_service import (
    primary_disease_prediction,
    secondary_disease_prediction,
)

router = APIRouter()


@router.post(
    "/primary_disease_prediction/", response_model=PrimaryDiseasePredictionResponse
)
async def disease_prediction_endpoint(input_data: UserSymptomInput):
    return await primary_disease_prediction(input_data)


@router.post("/secondary_disease_prediction/", response_model=PredictedDisease)
async def secondary_disease_prediction_endpoint(input_data: UserQuestionResponse):
    return await secondary_disease_prediction(input_data)
