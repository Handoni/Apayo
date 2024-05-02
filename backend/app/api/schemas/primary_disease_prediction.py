from pydantic import BaseModel
from typing import List

#사용자가 입력한 증상
class User_Symptom_Input(BaseModel):
    symptoms: str

#GPT가 추출한 증상
class Symptom(BaseModel):
    id: int
    symptoms: str

#GPT가 추출한 질병과 ICD 코드
class Disease(BaseModel):
    name: str
    code: str

#GPT가 생성한 질문 (1개의 질병:n개의 질의)
class DiseaseRelatedQuestions(BaseModel):
    id: int
    disease: Disease
    questions: List[Symptom]

#프론트에 전달할 응답
class PrimaryDiseasePredictionResponse(BaseModel):
    id: int
    symptoms: List[str]
    questions: List[DiseaseRelatedQuestions]
