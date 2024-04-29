from app.api.schemas.primary_disease_prediction import *


def parse_gpt_response(response: str) -> list:
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
