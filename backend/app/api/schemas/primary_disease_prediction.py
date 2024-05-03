from pydantic import BaseModel, Field
from typing import List, Dict
from uuid import uuid4

def generate_uuid() -> str:
    return str(uuid4())

#사용자가 입력한 증상
class UserSymptomInput(BaseModel):
    user_id: str
    symptoms: str

#GPT가 추출한 증상
class Symptom(BaseModel):
    id: str = Field(default_factory=generate_uuid)
    description: str

#GPT가 추출한 질병과 ICD 코드
class Disease(BaseModel):
    code: str
    name: str


#GPT가 생성한 질문 (1개의 질병:n개의 질의)
class DiseaseRelatedQuestions(BaseModel):
    id: str = Field(default_factory=generate_uuid)
    disease: Disease
    questions: List[Symptom]


#프론트에 전달할 응답
class PrimaryDiseasePredictionResponse(BaseModel):
    session_id: str
    symptoms: List[str]
    questions: Dict[str, str]
