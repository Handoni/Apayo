from pydantic import BaseModel

class SymptomInput(BaseModel):
    symptoms: str