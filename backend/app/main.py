from fastapi import FastAPI
from app.api.routers.disease_router import router as api_router
import uvicorn

app = FastAPI()

app.include_router(api_router)


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
