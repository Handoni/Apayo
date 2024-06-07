from pydantic import BaseModel
from typing import List, Dict
from uuid import uuid4


def generate_uuid() -> str:
    return str(uuid4())


# 사용자가 입력한 증상
class UserSymptomInput(BaseModel):
    user_id: str
    symptoms: str

#GPT가 응답할 스키마
PRIMARY_PREDICTION_SCHEMA = {
    "name": "disease_prediction",
    "description": "Predicts the disease based on the symptoms",
    "parameters":{
        "type": "object",
        "properties": {
            "user_input": {
                "type": "string",
                "description": "The symptoms of the user"
            },
            "symptoms": {
                "type": "array",
                "description": "Extracted symptoms of the user",
                "items": {
                    "type": "string"
                }
            },
            "diseases_symptoms_pair": {
                "type": "array",
                "description": "The predicted diseases and their additional symptoms",
                "items": {
                    "type": "object",
                    "properties": {
                        "Disease": {
                            "type": "object",
                            "description": "The predicted disease of the user",
                            "properties": {
                                "ICD_code": {"type": "string"},
                                "name": {"type": "string"}
                            }
                        },
                        "Additional Symptoms": {
                            "type": "array",
                            "description": "The additional symptoms of the user",
                            "items": {
                                "type": "string"
                            }
                        }
                    }
                }
            }
        
        },
        "required": ["symptoms","diseases_symptoms_pair"]
    }
}

# 프론트에 전달할 응답
class PrimaryDiseasePredictionResponse(BaseModel):
    session_id: str
    symptoms: List[str]
    questions: Dict[str, str]  # 질문ID:질문내용
