from app.utils.data_processing import parse_gpt_response
from app.api.schemas.primary_disease_prediction import *


def test_data_processing():
    input = "1. 증상1, 증상2 \n 2. 질병1, 질병2 \n 3. 질병1:code1, 증상1, 증상2, 증상3 / 질병2:code2, 증상1, 증상2, 증상3"

    processed_data = parse_gpt_response(input)

    symptoms = ["증상1", "증상2"]
    questions = [
        DiseaseRelatedQuestions(
            id=0,
            disease=Disease(name="질병1", code="code1"),
            questions=[
                Symptom(id=0, symptoms="증상1"),
                Symptom(id=0, symptoms="증상2"),
                Symptom(id=0, symptoms="증상3"),
            ],
        ),
        DiseaseRelatedQuestions(
            id=0,
            disease=Disease(name="질병2", code="code2"),
            questions=[
                Symptom(id=0, symptoms="증상1"),
                Symptom(id=0, symptoms="증상2"),
                Symptom(id=0, symptoms="증상3"),
            ],
        ),
    ]

    expected_output = (symptoms, questions)

    assert processed_data == expected_output
