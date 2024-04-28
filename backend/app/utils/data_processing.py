from app.api.schemas.disease_prediction_schema import *


def parse_gpt_response(response: str) -> list:
    if "no symptoms" in response.lower():
        return None

    responses = response.split("\n")

    symptoms = [_.strip() for _ in responses[0].replace("1.", "").split(",")]

    # Extract the disease-symptom pairs
    temp = []
    for pair in responses[2].split("/"):
        temp.append([_.strip() for _ in pair.replace("3.", "").split(",")])

    questions = []
    for i in temp:
        name, code = i[0].split(":")
        name = name.strip()
        code = code.strip()
        disease = Disease(name=name, code=code)
        questions.append(SymptomQuestion(id=0, disease=disease, question=i[1:]))

    return symptoms, questions
