from app.utils.data_processing import parse_primary_response
from app.api.schemas.primary_disease_prediction import *
from app.api.schemas.disease_prediction_session import DiseasePredictionSession

# from app.api.schemas.secondary_disease_prediction import *
from app.utils.data_processing import *


def test_parse_primary_response():
    input = "1. 증상1| 증상2 \n 2. code1:질병1| code2:질병2 \n 3. code1:질병1| 증상1| 증상2|증상3 / code2:질병2| 증상1| 증상2| 증상3"

    processed_data = parse_primary_response(input)

    symptoms = ["증상1", "증상2"]
    for i, symptom in enumerate(processed_data[0].values()):
        assert symptom == symptoms[i]

    diseases = {"code1": "질병1", "code2": "질병2"}
    assert processed_data[1] == diseases


def test_create_secondary_input():
    session = DiseasePredictionSession(
        user_id="user_id",
        session_id="session_id",
        primary_symptoms={
            "id1": "증상1",
            "id2": "증상2",
        },
        primary_diseases={
            "code1": "질병1",
            "code2": "질병2",
        },
        primary_questions={
            "code1": {
                "id1": "질문1",
                "id2": "질문2",
            },
            "code2": {
                "id3": "질문3",
                "id4": "질문4",
            },
        },
    )

    input_data = UserQuestionResponse(
        session_id="session_id",
        responses={
            "id1": "response1",
            "id2": "response2",
        },
    )
    result = ""
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

    assert (
        result
        == "증상1, 증상2\ncode1:질병1, code2:질병2\n질문1:response1, 질문2:response2"
    )
