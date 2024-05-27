from api.schemas.primary_disease_prediction import UserSymptomInput
from api.schemas.secondary_disease_prediction import UserQuestionResponse
from utils.data_processing import (
    parse_diseases,
    parse_questions,
    parse_symptoms,
    create_secondary_input,
    parse_secondary_response,
)
from fastapi import HTTPException
from core.prompt import (
    PRIMARY_DISEASE_PREDICTION_PROMPT1,
    PRIMARY_DISEASE_PREDICTION_PROMPT2,
    PRIMARY_DISEASE_PREDICTION_PROMPT3,
    SECONDARY_DISEASE_PREDICTION_PROMPT,
)
from utils.api_client import get_gpt_response
from services.firebase_service import SessionManager


async def primary_disease_prediction(input_data: UserSymptomInput):
    response1 = await get_gpt_response(
        input_data.symptoms, PRIMARY_DISEASE_PREDICTION_PROMPT1
    )
    symptoms = parse_symptoms(response1)
    if not symptoms:
        raise HTTPException(status_code=400, detail="Bad Request: failed to find symptoms")
    
    input2 = "User Symptom: " + input_data.symptoms + " " + "expected symptoms: " + response1
    response2 = await get_gpt_response(input2, PRIMARY_DISEASE_PREDICTION_PROMPT2)
    diseases = parse_diseases(response2)
    if not diseases:
        raise HTTPException(status_code=404, detail="Not Found: failed to find diseases")
    
    input3 = "User Symptom: " + response1 + " " + "Disease: " + response2
    response3 = await get_gpt_response(input3, PRIMARY_DISEASE_PREDICTION_PROMPT3)
    questions = parse_questions(response3)
    if not questions:
        raise HTTPException(status_code=404, detail="Not Found: failed to find questions")

    session = SessionManager.create_session(user_id=input_data.user_id)

    # Update session with new data
    SessionManager.update_session(
        session.session_id,
        {
            "user_input": input_data.symptoms,
            "primary_symptoms": symptoms,
            "primary_diseases": diseases,
            "primary_questions": questions,
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
            "secondary_symptoms": input_data.model_dump(),
            "final_diseases": response.Disease,
            "recommended_department": response.recommended_department,
            "final_disease_description": response.description,
        },
    )
    return response
