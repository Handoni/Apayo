from openai import OpenAI
import pandas as pd
import numpy as np
from core.config import get_settings
from firebase_admin import firestore
from google.cloud.firestore_v1.vector import Vector
import time
from core.firebase import initialize_firebase

initialize_firebase()

settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
client = OpenAI(api_key=GPT_API_KEY)

firestore_client = firestore.client()
def get_embedding(text):
    return client.embeddings.create(input = [text], model='text-embedding-3-small').data[0].embedding

def get_last_saved_disease():
    diseases_ref = firestore_client.collection("diseases_embeddings")
    docs = diseases_ref.order_by("id", direction=firestore.Query.DESCENDING).stream()
    for doc in docs:
        return doc.id  # 가장 마지막에 저장된 질병명을 반환
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
        disease_embedding = {"embedding": Vector(get_embedding(disease))}
        
        # 질병 문서 생성
        disease_ref = firestore_client.collection("diseases_embeddings").document(disease)
        disease_ref.set(disease_embedding)

        # 각 증상을 서브컬렉션에 추가
        symptoms_collection = disease_ref.collection("symptoms")
        for symptom in symptoms:
            # 증상 값이 유효한지 확인
            symptom = symptom.strip()
            if symptom:
                symptom_embedding = {"embedding": Vector(get_embedding(symptom))}
                symptoms_collection.document(symptom).set(symptom_embedding)
