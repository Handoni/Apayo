from openai import OpenAI
import pandas as pd
import numpy as np
from pymongo import MongoClient, ASCENDING, DESCENDING
from core.config import get_settings

settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
client = OpenAI(api_key=GPT_API_KEY)

mongo_client = MongoClient(settings.mongo_uri)
db = mongo_client['disease_embedding_db']

def get_embedding(text):
    return client.embeddings.create(input=[text], model='text-embedding-3-small').data[0].embedding

def get_last_saved_disease():
    disease = db.diseases_embeddings.find_one(sort=[("id", DESCENDING)])
    if disease:
        return disease["id"]
    return None

def create_embedding_data():
    df = pd.read_csv('C:/Users/이상윤/Documents/coding/Apayo/backend/app/data/output.csv')
    df.fillna(method='ffill', inplace=True)
    df.applymap(lambda x: x.replace('\xa0','').replace('\xa9','') if type(x) == str else x)

    # last_saved_disease = get_last_saved_disease()
    # start_saving = last_saved_disease is None
    # print(f"Last saved disease: {last_saved_disease}")
    start_saving = False

    # 질병별로 그룹화 및 처리
    for disease, group in df.groupby("Disease"):
        if not start_saving:
            if disease == 'obesity morbid':
                start_saving = True
            continue
        print(f"Processing {disease}")
        symptoms = group["Symptom"].tolist()
        disease_embedding = {"embedding": get_embedding(disease)}
        
        # 질병 문서 생성
        disease_data = {
            "_id": disease,
            "embedding": disease_embedding
        }
        db.diseases_embeddings.insert_one(disease_data)

        # 각 증상을 서브컬렉션에 추가
        for symptom in symptoms:
            # 증상 값이 유효한지 확인
            symptom = symptom.strip()
            if symptom:
                symptom_embedding = {"embedding": get_embedding(symptom)}
                symptom_data = {
                    "disease_id": disease,
                    "symptom": symptom,
                    "embedding": symptom_embedding
                }
                db.symptoms.insert_one(symptom_data)

# if __name__ == "__main__":
#     create_embedding_data()
