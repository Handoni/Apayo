from app.api.schemas.primary_disease_prediction import *
from app.api.schemas.secondary_disease_prediction import *
import re


def parse_primary_response(response: str) -> list:
    if "no symptoms" in response.lower():
        return None
    responses = re.split(r"\n+", response)

    symptoms = [_.strip() for _ in responses[0].replace("1.", "").split("|")]
    raw_diseases = responses[1].replace("2.", "").split("|")

    diseases = []
    for i in raw_diseases:
        code, name = i.split(":")
        code = code.strip()
        name = name.strip()
        diseases.append(Disease(code=code, name=name))

    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append([_.strip() for _ in pair.replace("3.", "").split("|")])

    question = []
    for i in temp:
        code, name = i[0].split(":")
        code = code.strip()
        name = name.strip()

        question.append(
            DiseaseRelatedQuestions(
                disease=Disease(code=code, name=name),
                questions=[Symptom(description=_.strip()) for _ in i[1:]],
            )
        )

    return symptoms, diseases, question


def create_secondary_input():
    pass


def parse_secondary_response(response: str) -> list:
    pass
