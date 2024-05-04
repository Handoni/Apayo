from pydantic import BaseModel, Field
from app.api.schemas.primary_disease_prediction import (
    Symptom,
    Disease,
    DiseaseRelatedQuestions,
    PrimaryDiseasePredictionResponse,
)
from app.api.schemas.secondary_disease_prediction import (
    UserSymptomResponse,
    PredictedDisease,
)
from typing import List
from uuid import uuid4
from datetime import datetime


def generate_uuid() -> str:
    return str(uuid4())


class DiseasePredictionSession(BaseModel):
    user_id: str
    session_id: str = Field(default_factory=generate_uuid)
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)

    primary_symptoms: List[Symptom] = []
    primary_diseases: List[Disease] = []
    primary_questions: List[DiseaseRelatedQuestions] = []

    secondary_symptoms: List[UserSymptomResponse] = []

    final_diseases: List[PredictedDisease] = []

    def prepare_primary_disease_prediction_response(
        self,
    ) -> PrimaryDiseasePredictionResponse:
        return PrimaryDiseasePredictionResponse(
            session_id=self.session_id,
            symptoms=[symptom.description for symptom in self.primary_symptoms],
            questions={
                symptom.id: symptom.description
                for question in self.primary_questions
                for symptom in question.questions
            },
        )
