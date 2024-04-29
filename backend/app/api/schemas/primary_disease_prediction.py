from pydantic import BaseModel
from typing import List


class Symptom(BaseModel):
    id: int
    symptoms: str


class Disease(BaseModel):
    name: str
    code: str


class DiseaseRelatedQuestions(BaseModel):
    id: int
    disease: Disease
    questions: List[Symptom]


class DiseasePredictionResponse(BaseModel):
    id: int
    symptoms: List[str]
    questions: List[DiseaseRelatedQuestions]
