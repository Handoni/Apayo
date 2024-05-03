from pydantic import BaseModel, Field
from app.api.schemas.primary_disease_prediction import *
from typing import List

class DiseasePredictionSession(BaseModel):
    user_id: str
    session_id: str = Field(default_factory=generate_uuid)
    
    primary_symptoms: List[Symptom]
    primary_diseases: List[Disease]
    primary_questions: List[DiseaseRelatedQuestions]
    
    def prepare_primary_disease_prediction_response(self) -> PrimaryDiseasePredictionResponse:
        return PrimaryDiseasePredictionResponse(
            session_id=self.session_id,
            
            symptoms=[symptom.description for symptom in self.primary_symptoms],
            
            questions={symptom.id:symptom.description for question in self.primary_questions for symptom in question.questions}
        )