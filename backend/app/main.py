from fastapi import FastAPI, Request
from api.exceptions.general_exception_handler import setup_exception_handlers
from api.routers.disease_prediction_router import router as api_router
from api.routers.user_router import router as user_router
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from core.logging_config import configure_logging
from core.middlewares import LoggingMiddleware

app = FastAPI()

app.include_router(api_router)
app.include_router(user_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://52.79.91.82",
        "http://52.79.91.82:80",
    ],
    allow_credentials=True,
    allow_methods=["*"],  # 모든 HTTP 메서드 허용
    allow_headers=["*"],
)
setup_exception_handlers(app)
configure_logging()

app.add_middleware(LoggingMiddleware)

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
