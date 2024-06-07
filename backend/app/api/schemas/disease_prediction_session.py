from pydantic import BaseModel, Field
from api.schemas.primary_disease_prediction import (
    PrimaryDiseasePredictionResponse,
)
from typing import Dict, Optional
from uuid import uuid4
from datetime import datetime


def generate_uuid() -> str:
    return str(uuid4())


class DiseasePredictionSession(BaseModel):
    user_id: str
    session_id: str = Field(default_factory=generate_uuid)
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)

    user_input: str = None
    primary_symptoms: Dict[str, str] = {}  # 증상ID:증상내용
    primary_diseases: Dict[str, str] = {}  # 질병 코드:질병 이름
    primary_questions: Dict[str, Dict[str, str]] = {}  # 질병 코드:{질문ID:질문내용}

    secondary_symptoms: Optional[Dict[str, str]] = {}  # 증상ID:응답

    final_diseases: Optional[str] = None
    recommended_department: Optional[str] = None 
    final_disease_description: Optional[str] = None

    real_disease: Optional[str] = None

    def prepare_primary_disease_prediction_response(
        self,
    ) -> PrimaryDiseasePredictionResponse:
        return PrimaryDiseasePredictionResponse(
            session_id=self.session_id,
            symptoms=list(self.primary_symptoms.values()),
            questions={
                k: v
                for disease in self.primary_questions.values()
                for k, v in disease.items()
            },
        )
