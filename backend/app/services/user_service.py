
from api.schemas.user import UserCreate
from utils.hashing import get_password_hash, verify_password
import uuid
from pymongo import MongoClient
from core.config import get_settings


settings = get_settings()
client = MongoClient(settings.mongo_uri)
db=client['Apayo']
def create_user(user: UserCreate):
    user_id = str(uuid.uuid4())
    hashed_password = get_password_hash(user.password)
    user_data = {
        'nickname': user.nickname,
        'hashed_password': hashed_password,
        'sex': user.sex,
        'age': user.age
    }
    db.users.insert_one({'_id': user_id, **user_data})
    user_data['id'] = user_id
    return user_data

def get_user_by_nickname(nickname: str):
    user_data = db.users.find_one({'nickname': nickname})
    if user_data:
        user_data['id'] = str(user_data['_id'])
        return user_data
    return None

def get_user_by_id(user_id: str):
    user_data = db.users.find_one({'_id': user_id})
    if user_data:
        user_data['id'] = str(user_data['_id'])
        return user_data
    return None

def authenticate_user(nickname: str, password: str):
    user_data = get_user_by_nickname(nickname)
    if user_data and verify_password(password, user_data['hashed_password']):
        return user_data
    return None