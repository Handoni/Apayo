from pydantic import BaseModel, Field
from typing import List
from app.api.schemas.primary_disease_prediction import SymptomQuestion, DiseaseRelatedQuestions

class UserSymptomResponse(BaseModel):
    id: int
    question: SymptomQuestion
    response: str
    
class UserDiseaseRelatedResponse(BaseModel):
    id: int
    disease: DiseaseRelatedQuestions
    questions: List[UserSymptomResponse]
    
