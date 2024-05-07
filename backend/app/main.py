from fastapi import FastAPI
from app.api.routers.disease_prediction_router import router as api_router
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from firebase_admin import credentials, initialize_app
from app.core.config import get_settings

app = FastAPI()

app.include_router(api_router)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "*"
    ],  # 모든 출처 허용 (보안상 운영 환경에선 지정된 출처만 허용할 것)
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],
)

Settings = get_settings()

cred = credentials.Certificate(Settings.google_application_credentials)


if __name__ == "__main__":
    initialize_app(cred)
    uvicorn.run(app, host="127.0.0.1", port=8000)
