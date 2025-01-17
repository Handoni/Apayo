import re
from api.schemas.secondary_disease_prediction import (
    UserQuestionResponse,
)
from services.session_service import SessionManager
from fastapi import HTTPException


def create_secondary_input(input_data: UserQuestionResponse) -> str:
    print(input_data.responses)
    session = SessionManager.get_session_by_id(input_data.session_id)
    result = ""

    result += "User Symptoms:" + session.user_input + "\n"

    result += "Extracted Symptoms:"
    result += ", ".join(session.primary_symptoms.values())
    result += "\n"

    result += "Predicted Diseases:"
    result += ", ".join(
        ["{}:{}".format(k, v) for k, v in session.primary_diseases.items()]
    )
    result += "\n"

    merged_questions = {}
    for questions in session.primary_questions.values():
        merged_questions.update(questions)
    temp = []
    for id, response in input_data.responses.items():
        if id not in merged_questions:
            raise HTTPException(status_code=404, detail="Question not found")
        temp.append(f"{merged_questions[id]}:{response}")

    result += "Additional Symptoms: "
    result += ", ".join(temp)

    return result


def get_disease_info(diseases: dict):
    """Get the disease information from the user's responses."""
    disease_info = {}
    for disease, response in diseases.items():
        disease_info[disease] = response
    return disease_info
