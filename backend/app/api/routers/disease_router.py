from fastapi import APIRouter
from app.models.symptom_input import SymptomInput
from app.services.gpt_service import disease_prediction

router = APIRouter()


@router.post("/disease_prediction/")
async def disease_prediction_endpoint(input_data: SymptomInput):
    return await disease_prediction(input_data)
