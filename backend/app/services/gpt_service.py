from app.api.schemas.primary_disease_prediction import Symptom
from app.api.schemas.secondary_disease_prediction import SecondaryDiseasePredictionRequest
from app.utils.data_processing import *
from fastapi import HTTPException
from app.core.prompt import *
from app.utils.api_client import get_gpt_response


async def primary_disease_prediction(input_data: str):
    response = await get_gpt_response(
        input_data, PRIMARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_primary_response(response)

    if not response:
        raise HTTPException(status_code=404, detail="failed to find symptoms")
    return {
        "id": 0,
        "symptoms": response[0],
        "questions": response[1],
    }


async def secondary_disease_prediction(input_data: SecondaryDiseasePredictionRequest):
    
    response = await get_gpt_response(
        create_secondary_input(input_data), SECONDARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_secondary_response(response)
    
    if not response:
        raise HTTPException(status_code=404, detail="failed to get response")
    return
