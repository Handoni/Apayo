from fastapi import APIRouter, HTTPException, Depends
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from api.schemas.user import UserCreate, User, Token
from services.user_service import create_user, authenticate_user, get_user_by_id, get_user_by_nickname
from utils.jwt_handler import create_access_token, decode_access_token
import jwt
from api.schemas.disease_prediction_session import DiseasePredictionSession
from services.session_service import SessionManager
from typing import List

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@router.post("/register", response_model=User)
def register_user(user: UserCreate):
    existing_user = get_user_by_nickname(user.nickname)
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    try:
        user_record = create_user(user)
        return User(id=user_record['id'], nickname=user_record['nickname'], sex=user_record['sex'], age=user_record['age'])
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login", response_model=Token)
def login_user(form_data: OAuth2PasswordRequestForm = Depends()):
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Invalid nickname or password")
    
    access_token = create_access_token(data={"user_id": user['id']})
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/users/me/", response_model=User)
def read_users_me(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        user_id = decode_access_token(token)
        user = get_user_by_id(user_id)
        if user is None:
            raise credentials_exception
        return User(id=user['id'], nickname=user['nickname'], sex=user['sex'], age=user['age'])
    except jwt.PyJWTError:
        raise credentials_exception

@router.get("/users/me/sessions", response_model=List[DiseasePredictionSession])
def get_user_sessions(token: str = Depends(oauth2_scheme)):
    user_id = decode_access_token(token)
    return SessionManager.get_session_by_user(user_id)
