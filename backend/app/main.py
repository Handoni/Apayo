from fastapi import FastAPI
from api.routers.disease_prediction_router import router as api_router
from api.routers.user_router import router as user_router
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from firebase_admin import credentials, initialize_app
from core.config import get_settings
import base64
import json
app = FastAPI()

app.include_router(api_router)
<<<<<<< Updated upstream
=======
app.include_router(user_router)

>>>>>>> Stashed changes
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://apayo-d426b.firebaseapp.com/",
        "https://apayo-d426b.web.app/",
        "http://localhost:3000",
        "http://localhost:8000",
        "http://localhost:8080",
    ],
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],
)

Settings = get_settings()

cred = credentials.Certificate(json.loads(base64.b64decode(Settings.google_application_credentials)))
initialize_app(cred)

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
