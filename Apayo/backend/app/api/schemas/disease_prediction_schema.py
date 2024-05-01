from pydantic import BaseModel, Field
from typing import List, Dict

class SymptomInput(BaseModel):
    symptoms: str

class DiseasePredictionResponse(BaseModel):
    symptoms: List[str]
    diseases: List[str]
    disease_symptom_pairs: Dict[str, List[str]]