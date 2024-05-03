from app.utils.data_processing import parse_primary_response
from app.api.schemas.primary_disease_prediction import *
# from app.api.schemas.secondary_disease_prediction import *
from app.utils.data_processing import *


def test_parse_primary_response():
    input = "1. 증상1, 증상2 \n 2. code1:질병1, code2:질병2 \n 3. code1:질병1, 증상1, 증상2, 증상3 / code2:질병2, 증상1, 증상2, 증상3"

    processed_data = parse_primary_response(input)

    symptoms = ["증상1", "증상2"]
    diseases = [Disease(code="code1", name="질병1"), Disease(code="code2", name="질병2")]
    questions = [
        DiseaseRelatedQuestions(
            disease=Disease(code="code1", name="질병1"),
            questions=[
                Symptom(symptoms="증상1"),
                Symptom(symptoms="증상2"),
                Symptom(symptoms="증상3")
            ]
            ), 
        DiseaseRelatedQuestions(
            disease=Disease(code="code2", name="질병2"), 
            questions=[
                Symptom(symptoms="증상1"),
                Symptom(symptoms="증상2"),
                Symptom(symptoms="증상3")
            ]
        )
        ]

    assert processed_data[0] == symptoms
    for d1, d2 in zip(processed_data[1], diseases):
        assert d1.code == d2.code
        assert d1.name == d2.name
        
    for q1, q2 in zip(processed_data[2], questions):
        assert q1.disease.code == q2.disease.code
        assert q1.disease.name == q2.disease.name
        for s1, s2 in zip(q1.questions, q2.questions):
            assert s1.symptoms == s2.symptoms

# def test_create_secondary_input():
#     data = SecondaryDiseasePredictionRequest(
#         data=[
#             UserDiseaseRelatedResponse(
#                 id=0,
#                 questions=DiseaseRelatedQuestions(
#                     id=0,
#                     disease=Disease(name="질병1", code="code1"),
#                     questions=[
#                         Symptom(id=0, symptoms="증상1"),
#                         Symptom(id=0, symptoms="증상2"),
#                         Symptom(id=0, symptoms="증상3"),
#                     ],
#                 ),
#                 responses=[
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상1"), response="yes"),
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상2"), response="no"),
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상3"), response="yes"),
#                 ],
#             ),
#             UserDiseaseRelatedResponse(
#                 id=0,
#                 questions=DiseaseRelatedQuestions(
#                     id=0,
#                     disease=Disease(name="질병2", code="code2"),
#                     questions=[
#                         Symptom(id=0, symptoms="증상1"),
#                         Symptom(id=0, symptoms="증상2"),
#                         Symptom(id=0, symptoms="증상3"),
#                     ],
#                 ),
#                 responses=[
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상1"), response="yes"),
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상2"), response="no"),
#                     UserSymptomResponse(id=0, question=Symptom(id=0, symptoms="증상3"), response="yes"),
#                 ],
#             ),
#         ]
#     )

#     processed_data = create_secondary_input(data)

#     expected_output = "질병1(code1):[증상1:yes, 증상2:no, 증상3:yes]\n질병2(code2):[증상1:yes, 증상2:no, 증상3:yes]\n"

#     assert processed_data == expected_output