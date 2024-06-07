from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import logging

logger = logging.getLogger("fastapi_logger")

def setup_exception_handlers(app: FastAPI):
    # 커스텀 예외 핸들러
    @app.exception_handler(Exception)
    async def custom_exception_handler(request: Request, exc: Exception):
        logger.error(f"Unhandled Exception: {str(exc)}", exc_info=True)
        return JSONResponse(
            status_code=500,
            content={"message": "An unexpected error occurred."},
        )

    # HTTPException 핸들러
    @app.exception_handler(HTTPException)
    async def http_exception_handler(request: Request, exc: HTTPException):
        logger.error(f"HTTPException: {exc.detail}", exc_info=True)
        return JSONResponse(
            status_code=exc.status_code,
            content={"message": exc.detail},
        )
