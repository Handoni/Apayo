from app.utils.data_processing import parse_primary_response
from app.api.schemas.primary_disease_prediction import *
from app.api.schemas.secondary_disease_prediction import *
from app.utils.data_processing import *


def test_parse_primary_response():
    input = "1. 증상1, 증상2 \n 2. 질병1, 질병2 \n 3. 질병1:code1, 증상1, 증상2, 증상3 / 질병2:code2, 증상1, 증상2, 증상3"

    processed_data = parse_primary_response(input)

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

def test_create_secondary_input():
    data = SecondaryDiseasePredictionRequest(
        data=[
            UserDiseaseRelatedResponse(
                id=0,
                questions=DiseaseRelatedQuestions(
                    id=0,
                    disease=Disease(name="질병1", code="code1"),
                    questions=[
                        Symptom(id=0, symptoms="증상1"),
                        Symptom(id=0, symptoms="증상2"),
                        Symptom(id=0, symptoms="증상3"),
                    ],
                ),
                responses=[
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상1"), response="yes"),
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상2"), response="no"),
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상3"), response="yes"),
                ],
            ),
            UserDiseaseRelatedResponse(
                id=0,
                questions=DiseaseRelatedQuestions(
                    id=0,
                    disease=Disease(name="질병2", code="code2"),
                    questions=[
                        Symptom(id=0, symptoms="증상1"),
                        Symptom(id=0, symptoms="증상2"),
                        Symptom(id=0, symptoms="증상3"),
                    ],
                ),
                responses=[
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상1"), response="yes"),
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상2"), response="no"),
                    UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상3"), response="yes"),
                ],
            ),
        ]
    )

    processed_data = create_secondary_input(data)

    expected_output = "질병1(code1):[증상1:yes, 증상2:no, 증상3:yes]\n질병2(code2):[증상1:yes, 증상2:no, 증상3:yes]\n"

    assert processed_data == expected_output