from app.core.config import get_settings
from app.api.schemas.primary_disease_prediction import Symptom
from openai import OpenAI
from app.core.prompt import *


async def get_gpt_response(input_data, system_message):
    settings = get_settings()
    GPT_API_KEY = settings.gpt_api_key
    MODEL = "gpt-3.5-turbo"

    client = OpenAI(
        api_key=GPT_API_KEY,
    )
    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": system_message},
            {"role": "user", "content": input_data},
        ],
        stop=None,
        temperature=0.5,
    )
    return response.choices[0].message.content
