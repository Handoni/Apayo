from firebase_admin import firestore
from api.schemas.user import UserCreate
from utils.hashing import get_password_hash, verify_password
import uuid

db = firestore.client()

def create_user(user: UserCreate):
    user_id = str(uuid.uuid4())
    hashed_password = get_password_hash(user.password)
    user_data = {
        'email': user.email,
        'nickname': user.nickname,
        'hashed_password': hashed_password,
        'sex': user.sex,
        'age': user.age
    }
    db.collection('users').document(user_id).set(user_data)
    user_data['id'] = user_id
    return user_data

def get_user_by_email(email: str):
    user_query = db.collection('users').where('email', '==', email).stream()
    for user in user_query:
        user_data = user.to_dict()
        user_data['id'] = user.id
        return user_data
    return None

def authenticate_user(email: str, password: str):
    user_data = get_user_by_email(email)
    if user_data and verify_password(password, user_data['hashed_password']):
        return user_data
    return None
