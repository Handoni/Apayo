from app.api.schemas.primary_disease_prediction import *
from app.api.schemas.secondary_disease_prediction import *

def parse_primary_response(response: str) -> list:
    if "no symptoms" in response.lower():
        return None

    responses = response.split("\n")

    symptoms = [_.strip() for _ in responses[0].replace("1.", "").split(",")]

    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append([_.strip() for _ in pair.replace("3.", "").split(",")])

    question = []
    for i in temp:
        name, code = i[0].split(":")
        name = name.strip()
        code = code.strip()
        disease = Disease(name=name, code=code)
        question.append(
            DiseaseRelatedQuestions(
                id=0,
                disease=disease,
                questions=list(map(lambda x: Symptom(id=0, symptoms=x.strip()), i[1:])),
            )
        )

    return symptoms, question

def create_secondary_input(input_data: SecondaryDiseasePredictionRequest) -> str:
    data = input_data.data

    result = ""
    for i in data:
        result += f"{i.questions.disease.name}({i.questions.disease.code}):["
        for j in i.responses:
            result += f"{j.question.symptoms}:{j.response}, "
        result = result[:-2]
        result += "]\n"

    return result

def parse_secondary_response(response: str) -> list:
    pass