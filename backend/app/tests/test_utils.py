from app.utils.data_processing import parse_gpt_response
from app.api.schemas.disease_prediction_schema import *


def test_data_processing():
    input = "1. 증상1, 증상2 \n 2. 질병1, 질병2 \n 3. 질병1:code1, 증상1, 증상2, 증상3 / 질병2:code2, 증상1, 증상2, 증상3"

    processed_data = parse_gpt_response(input)

    symptoms = ["증상1", "증상2"]
    questions = [
        SymptomQuestion(
            id=0,
            disease=Disease(name="질병1", code="code1"),
            question=["증상1", "증상2", "증상3"],
        ),
        SymptomQuestion(
            id=0,
            disease=Disease(name="질병2", code="code2"),
            question=["증상1", "증상2", "증상3"],
        ),
    ]

    expected_output = (symptoms, questions)

    assert processed_data == expected_output
