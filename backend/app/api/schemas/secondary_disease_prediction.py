from pydantic import BaseModel
from typing import Dict
from uuid import uuid4


def generate_uuid() -> str:
    return str(uuid4())


class UserQuestionResponse(BaseModel):
    session_id: str
    responses: Dict[str, str]  # 질문ID:응답

SECONDARY_PREDICTION_SCHEMA = {
    "name": "disease_prediction",
    "description": "Predicts the disease based on the symptoms",
    "parameters": {
        "type": "object",
        "properties": {
            "user_input": {
                "type": "string",
                "description": "User input, main symptoms, predicted diseases, additional symptoms"
            },
            "Disease": {
                "type": "string",
                "description": "Predicted Disease"
            },
            "recommended_department": {
                "type": "string",
                "description": "Recommended Department"
            },
            "description": {
                "type": "string",
                "description": "Description of the disease"
            }
        },
        "required": ["Disease", "recommended_department", "description"]
    }
}


class PredictedDisease(BaseModel):
    Disease: str
    recommended_department: str
    description: str

class UserFeedback(BaseModel):
    session_id: str
    real_disease: str
    feedback: str