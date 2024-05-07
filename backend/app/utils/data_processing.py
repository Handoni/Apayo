import re
from api.schemas.secondary_disease_prediction import (
    UserQuestionResponse,
)
from services.firebase_service import SessionManager
from uuid import uuid4
from fastapi import HTTPException
from api.schemas.secondary_disease_prediction import PredictedDisease


def parse_primary_response(response: str) -> list:
    if "no symptoms" in response.lower():
        return None
    responses = re.split(r"\n+", response)
    print(responses)
    if len(responses) != 3:
        raise HTTPException(status_code=404, detail="Invalid response")

    symptoms = {
        str(uuid4()): _.strip() for _ in responses[0].replace("1.", "").split("|")
    }

    raw_diseases = responses[1].replace("2.", "").replace("ICD code:", "").split("|")

    diseases = {}
    for i in raw_diseases:
        code, name = i.split(":")
        code = code.strip()
        name = name.strip()
        diseases[code] = name

    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append(
            [
                _.strip()
                for _ in pair.replace("3.", "").replace("ICD code:", "").split("|")
            ]
        )

    question = {}
    for i in temp:
        code, name = i[0].split(":")
        code = code.strip()
        name = name.strip()

        question[code] = {str(uuid4()): j for j in i[1:]}

    return symptoms, diseases, question


def create_secondary_input(input_data: UserQuestionResponse) -> str:
    print(input_data.responses)
    result = ""
    session = SessionManager.get_session(input_data.session_id)
    result += ", ".join(session.primary_symptoms.values())
    result += "\n"
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

    result += ", ".join(temp)

    return result


def parse_secondary_response(response: str) -> list[PredictedDisease]:
    response = re.split(r"\n+", response)
    print(response)
    if len(response) > 2 or len(response) < 1:
        raise HTTPException(status_code=404, detail="Invalid response")
    result = {}
    for i in response:
        temp = i.split("|")
        result = PredictedDisease(
            Disease=temp[0].strip(),
            recommended_department=temp[1].strip(),
            description=temp[2].strip(),
        )
    return result
