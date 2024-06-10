from fastapi import APIRouter
from api.schemas.primary_disease_prediction import (
    UserSymptomInput,
    PrimaryDiseasePredictionResponse,
)
from api.schemas.secondary_disease_prediction import (
    UserQuestionResponse,
    PredictedDisease,
    UserFeedback,
)
from services.disease_prediction_service import (
    primary_disease_prediction,
    secondary_disease_prediction,
    feedback,
)
from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer
from utils.jwt_handler import decode_access_token
import jwt

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@router.post(
    "/api/primary_disease_prediction/", response_model=PrimaryDiseasePredictionResponse
)
async def disease_prediction_endpoint(input_data: UserSymptomInput, token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        user_id = decode_access_token(token)
    except jwt.PyJWTError:
        raise credentials_exception
    return await primary_disease_prediction(user_id, input_data)


@router.post("/api/secondary_disease_prediction/", response_model=PredictedDisease)
async def secondary_disease_prediction_endpoint(input_data: UserQuestionResponse, token: str = Depends(oauth2_scheme)):
    return await secondary_disease_prediction(input_data)

@router.post("/api/feedback/", response_model=str)
async def feedback_endpoint(input_data: UserFeedback, token: str = Depends(oauth2_scheme)):
    return await feedback(input_data)