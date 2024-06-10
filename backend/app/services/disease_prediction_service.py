from api.schemas.primary_disease_prediction import (
    UserSymptomInput,
    PRIMARY_PREDICTION_SCHEMA,
    SYMPTOM_EXTRACTION_SCHEMA,
)
from api.schemas.secondary_disease_prediction import (
    UserQuestionResponse,
    SECONDARY_PREDICTION_SCHEMA,
    UserFeedback,
)
from utils.data_processing import create_secondary_input
from fastapi import HTTPException
from core.prompt import (
    SYMPTOM_EXTRACTION_PROMPT,
    PRIMARY_DISEASE_PREDICTION_PROMPT,
    SECONDARY_DISEASE_PREDICTION_PROMPT,
)
from utils.api_client import get_gpt_response
from services.session_service import SessionManager
from uuid import uuid4
from utils.api_client import get_gpt_response
from utils.embedding_processing import find_similar_symptoms
import logging


logger = logging.getLogger("fastapi_logger")


async def primary_disease_prediction(user_id: str, input_data: UserSymptomInput):
    extracted_symptoms = await get_gpt_response(
        input_data.symptoms,
        SYMPTOM_EXTRACTION_PROMPT,
        SYMPTOM_EXTRACTION_SCHEMA,
        "symptom_extraction",
    )
    symptoms = {str(uuid4()): i for i in extracted_symptoms["symptoms"]}

    similar_symptoms = find_similar_symptoms(extracted_symptoms["symptoms"])

    response = await get_gpt_response(
        str(similar_symptoms),
        PRIMARY_DISEASE_PREDICTION_PROMPT,
        PRIMARY_PREDICTION_SCHEMA,
        "disease_prediction",
    )

    diseases = {}
    questions = {}

    for pair in response["diseases_symptoms_pair"]:
        diseases[pair["Disease"]["ICD_code"]] = pair["Disease"]["name"]
        questions[pair["Disease"]["ICD_code"]] = {
            str(uuid4()): j for j in pair["Additional Symptoms"]
        }

    session = SessionManager.create_session(user_id=user_id)
    SessionManager.update_session(
        session.session_id,
        {
            "user_input": input_data.symptoms,
            "primary_symptoms": symptoms,
            "primary_diseases": diseases,
            "primary_questions": questions,
        },
    )
    logger.info(f"Session created with id: {session.session_id}")
    temp = str(similar_symptoms).replace("\n", " ")
    logger.info(f"Embedded Data: {temp}")
    return session.prepare_primary_disease_prediction_response()


async def secondary_disease_prediction(input_data: UserQuestionResponse):
    session = SessionManager.get_session_by_id(input_data.session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    response = await get_gpt_response(
        create_secondary_input(input_data),
        SECONDARY_DISEASE_PREDICTION_PROMPT,
        SECONDARY_PREDICTION_SCHEMA,
        "disease_prediction",
    )
    if not response:
        raise HTTPException(status_code=404, detail="failed to get response")

    response_pair = list(session.model_dump()["primary_questions"].values())
    merged_dict = {k: v for d in response_pair for k, v in d.items()}
    symptoms = {
        symptoms: input_data.responses[id] for id, symptoms in merged_dict.items()
    }
    print(response)
    SessionManager.update_session(
        session.session_id,
        {
            "secondary_symptoms": symptoms,
            "final_diseases": response["Disease"],
            "recommended_department": response["recommended_department"],
            "final_disease_description": response["description"],
        },
    )
    return response

async def feedback(input_data: UserFeedback):
    session = SessionManager.get_session_by_id(input_data.session_id)
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    if SessionManager.get_session_by_id(input_data.session_id).final_diseases is None:
        raise HTTPException(status_code=404, detail="Disease not predicted yet")
    SessionManager.update_session(
        session.session_id,
        {
            "real_disease": input_data.real_disease,
            "feedback": input_data.feedback,
        },
    )
    return "Feedback received"