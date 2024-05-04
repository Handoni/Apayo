from app.api.schemas.primary_disease_prediction import UserSymptomInput
from app.api.schemas.secondary_disease_prediction import UserQuestionResponse
from app.utils.data_processing import (
    parse_primary_response,
    create_secondary_input,
    parse_secondary_response,
)
from fastapi import HTTPException
from app.core.prompt import (
    PRIMARY_DISEASE_PREDICTION_PROMPT,
    SECONDARY_DISEASE_PREDICTION_PROMPT,
)
from app.utils.api_client import get_gpt_response
from app.api.schemas.disease_prediction_session import DiseasePredictionSession
from app.services.firebase_service import SessionManager


async def primary_disease_prediction(input_data: UserSymptomInput):
    response = await get_gpt_response(
        input_data.symptoms, PRIMARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_primary_response(response)
    if not response:
        raise HTTPException(status_code=404, detail="failed to find symptoms")

    session = SessionManager.create_session(user_id=input_data.user_id)

    # Update session with new data
    SessionManager.update_session(
        session.session_id,
        {
            "primary_symptoms": response[0],
            "primary_diseases": response[1],
            "primary_questions": response[2],
        },
    )

    return session.prepare_primary_disease_prediction_response()


async def secondary_disease_prediction(input_data: UserQuestionResponse):
    session = SessionManager.get_session(input_data.session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    response = await get_gpt_response(
        create_secondary_input(input_data), SECONDARY_DISEASE_PREDICTION_PROMPT
    )

    response = parse_secondary_response(response)
    if not response:
        raise HTTPException(status_code=404, detail="failed to get response")

    SessionManager.update_session(
        session.session_id,
        {
            "secondary_symptoms": input_data,
            "final_diseases": response,
        },
    )
    return response
