from fastapi import APIRouter
from app.api.schemas.primary_disease_prediction import SymptomInput, DiseasePredictionResponse
from app.services.gpt_service import disease_prediction

router = APIRouter()


@router.post("/disease_prediction/", response_model=DiseasePredictionResponse)
async def disease_prediction_endpoint(input_data: SymptomInput):
    return await disease_prediction(input_data)
