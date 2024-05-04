from pydantic import BaseModel, field_validator, Field
from typing import List, Dict
from uuid import uuid4


def generate_uuid() -> str:
    return str(uuid4())


class UserSymptomResponse(BaseModel):
    question_id: str
    response: str

    @field_validator("response")
    @classmethod
    def validate_response(cls, v):
        if v.lower() not in ["yes", "no"]:
            raise ValueError("response must be 'yes' or 'no'")
        return v


class UserQuestionResponse(BaseModel):
    session_id: str
    responses: Dict[str, str]  # 질문ID:응답


class PredictedDisease(BaseModel):
    order: int
    Disease: str
    description: str
    recommended_department: str


class SecondaryDiseasePredictionResponse(BaseModel):
    data: List[PredictedDisease]
