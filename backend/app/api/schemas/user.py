from pydantic import BaseModel, EmailStr, validator

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: str | None = None

class UserCreate(BaseModel):
    nickname: str
    password: str
    sex: str
    age: int

    @validator("sex")
    def validate_sex(cls, v):
        if v not in ['male', 'female']:
            raise ValueError('Sex field must be either "male" or "female".')
        return v
    
    @validator("age")
    def validate_age(cls, v):
        if v < 0:
            raise ValueError('Age field must be a positive integer.')
        return v

class User(BaseModel):
    id: str
    nickname: str
    email: EmailStr
    sex: str
    age: int

    class Config:
        from_attributes = True
