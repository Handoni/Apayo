import re
from app.api.schemas.secondary_disease_prediction import UserQuestionResponse
from app.services.firebase_service import SessionManager
from uuid import uuid4


def parse_primary_response(response: str) -> list:
    if "no symptoms" in response.lower():
        return None
    responses = re.split(r"\n+", response)
    print(responses)

    symptoms = {
        str(uuid4()): _.strip() for _ in responses[0].replace("1.", "").split("|")
    }

    raw_diseases = responses[1].replace("2.", "").split("|")

    diseases = {}
    for i in raw_diseases:
        code, name = i.split(":")
        code = code.strip()
        name = name.strip()
        diseases[code] = name

    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append([_.strip() for _ in pair.replace("3.", "").split("|")])

    question = {}
    for i in temp:
        code, name = i[0].split(":")
        code = code.strip()
        name = name.strip()

        question[code] = {str(uuid4()): j for j in i[1:]}

    return symptoms, diseases, question


def create_secondary_input(input_data: UserQuestionResponse) -> str:
    result = ""
    session = SessionManager.get_session(input_data.session_id)
    primary_questions = session.primary_questions
    for id, response in input_data.responses:
        question = session.primary_questions[id]
        result += f"{question.disease.name} {response} "


def parse_secondary_response(response: str) -> list:
    pass
