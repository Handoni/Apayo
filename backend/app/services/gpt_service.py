from app.api.schemas.primary_disease_prediction import Symptom
from app.utils.data_processing import parse_gpt_response
from fastapi import HTTPException
from app.core.prompt import *
from app.utils.api_client import get_gpt_response


async def primary_disease_prediction(input_data: Symptom):
    response = await get_gpt_response(
        input_data.symptoms, PRIMARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_gpt_response(response)

    if not response:
        raise HTTPException(status_code=404, detail="failed to find symptoms")
    return {
        "id": 0,
        "symptoms": response[0],
        "questions": response[1],
    }


async def secondary_disease_prediction(input_data: Symptom):
    response = await get_gpt_response(
        input_data.symptoms, SECONDARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_gpt_response(response)
