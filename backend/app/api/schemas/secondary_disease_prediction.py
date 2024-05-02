from pydantic import BaseModel, field_validator
from typing import List
from app.api.schemas.primary_disease_prediction import *

class UserSymptomResponse(BaseModel):
    id: int
    question: Symptom
    response: str
    
    @field_validator("response")
    @classmethod
    def validate_response(cls, v):
        if v.lower() not in ["yes", "no"]:
            raise ValueError("response must be 'yes' or 'no'")
        return v
    
class UserDiseaseRelatedResponse(BaseModel):
    id: int
    responses: List[UserSymptomResponse]
    
class SecondaryDiseasePredictionRequest(BaseModel):
    data: List[UserDiseaseRelatedResponse]

class PredictedDisease(BaseModel):
    order: int
    Disease: str
    description: str

class SecondaryDiseasePredictionResponse(BaseModel):
    diseases: List[PredictedDisease]
    department: List[str]