from pydantic import BaseModel, Field
from typing import List, Dict


class SymptomInput(BaseModel):
    symptoms: str


class Disease(BaseModel):
    name: str
    code: str


class SymptomQuestion(BaseModel):
    id: int
    disease: Disease
    question: List[str]


class DiseasePredictionResponse(BaseModel):
    symptoms: List[str]
    questions: List[SymptomQuestion]
