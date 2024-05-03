from app.api.schemas.primary_disease_prediction import Symptom
from app.api.schemas.secondary_disease_prediction import SecondaryDiseasePredictionRequest
from app.utils.data_processing import *
from fastapi import HTTPException
from app.core.prompt import *
from app.utils.api_client import get_gpt_response
from app.api.schemas.disease_prediction_session import DiseasePredictionSession
from app.services.firebase_service import store_user_session

async def primary_disease_prediction(input_data: UserSymptomInput):
    response = await get_gpt_response(
        input_data.symptoms, PRIMARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_primary_response(response)
    if not response:
        raise HTTPException(status_code=404, detail="failed to find symptoms")
    
    session = DiseasePredictionSession(
        user_id=input_data.user_id,
        primary_symptoms=[Symptom(description=symptom) for symptom in response[0]],
        primary_diseases=response[1],
        primary_questions=response[2],
    )
    store_user_session(session)
    
    return session.prepare_primary_disease_prediction_response()


async def secondary_disease_prediction(input_data: SecondaryDiseasePredictionRequest):
    
    response = await get_gpt_response(
        create_secondary_input(input_data), SECONDARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_secondary_response(response)
    
    if not response:
        raise HTTPException(status_code=404, detail="failed to get response")
    return
