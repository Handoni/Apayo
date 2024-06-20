import logging

def configure_logging():
    logger = logging.getLogger("fastapi_logger")
    logger.setLevel(logging.DEBUG)

    # 핸들러 설정 (파일 핸들러)
    file_handler = logging.FileHandler("info.log")
    file_handler.setLevel(logging.DEBUG)

    # 포맷터 설정
    formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    file_handler.setFormatter(formatter)

    # 핸들러를 로거에 추가
    logger.addHandler(file_handler)
