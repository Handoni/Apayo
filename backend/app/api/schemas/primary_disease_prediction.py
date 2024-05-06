from pydantic import BaseModel, Field
from typing import List, Dict
from uuid import uuid4


def generate_uuid() -> str:
    return str(uuid4())


# 사용자가 입력한 증상
class UserSymptomInput(BaseModel):
    user_id: str
    symptoms: str


# 프론트에 전달할 응답
class PrimaryDiseasePredictionResponse(BaseModel):
    session_id: str
    symptoms: List[str]
    questions: Dict[str, str]  # 질문ID:질문내용
