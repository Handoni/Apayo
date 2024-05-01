from app.core.config import get_settings
from app.api.schemas.disease_prediction_schema import SymptomInput
from openai import OpenAI
from app.utils.data_processing import parse_gpt_response

async def disease_prediction(input_data: SymptomInput):
    settings = get_settings()
    GPT_API_KEY = settings.gpt_api_key
    MODEL = "gpt-3.5-turbo"

    SYSTEM_MESSAGE = "You are a useful medical assistant, \
        and you should play a role in analyzing the user's symptoms, predicting the disease associated with the symptoms, \
        and encouraging them to go to the relevant diagnostic department. \
        Follow these instructions step by step, answer line 1 for number 1 and line 2 for number 2. \
        Do not include index numbers in the response like '1.', '2.', so on. \
        Do not provide any information other than the instructions. \
        0. If input is totally irrelevant with the symptoms, please type 'No symptoms'. \
        1. Based on the symptoms stated by the user, you need to extract the main symptoms into words. \
            The symptom name follows the format: 한국어증상명(English Symptom name), e.g. 두통(headache) \
            Extract up to 10 symptom names, and separate them all into commas. \
            e.g. I have a headache and a cough --> 두통(headache), 기침(cough) \
        2. Based on the symptoms, you need to list the disease related to the symptoms.\
            Return 5 diseases in the most common order. \
            The disease name follows the format: 한국어질병명(English disease name), e.g. 감기(cold) \
            Print out only 5 disease names, separated by commas, without further explanation. \
        3. Based on the listed diseases, you need to list the symptoms of the disease to identify the user's disease. \
            List 3 symptoms per disease. \
            Symptoms are presented in easy and concise Korean sentences in the form of: '-한다', e.g. 감기(cold) --> 콧물이 난다. \
            Symptoms include only features that the user can feel and understand the terms, \
            and exclude features that require medical examination (features that may appear on e.g. X-rays or MRI pictures). \
            The output follows the format:\
            질병명1(disease name 1), 증상1, 증상2, 증상3 / 질병명2(disease name 2), 증상1, 증상2, 증상3 / ... \
            e.g. 감기(cold), 콧물이 난다, 기침이 나온다, 몸살이 난다 / 천식(asthma), 기침이 나온다, 호흡곤란하다, 가슴이 답답하다 / ..."

    client = OpenAI(
        api_key=GPT_API_KEY,
    )

    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": SYSTEM_MESSAGE},
            {"role": "user", "content": input_data.symptoms},
        ],
        stop=None,
        temperature=0.5,
    )
    response = response.choices[0].message.content
    #json으로 응답
    response = parse_gpt_response(response)
    return {
        "diseases": response[0],
        "symptoms": response[1],
        "disease_symptom_pairs": response[2]
    }
