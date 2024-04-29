from pydantic import BaseModel
from typing import List


class SymptomInput(BaseModel):
    id: int
    symptoms: str


class Disease(BaseModel):
    name: str
    code: str


class SymptomQuestion(BaseModel):
    id: int
    question: str
    
class DiseaseRelatedQuestions(BaseModel):
    id: int
    disease: Disease
    questions: List[SymptomQuestion]


class DiseasePredictionResponse(BaseModel):
    id: int
    symptoms: List[str]
    questions: List[DiseaseRelatedQuestions]
