from openai import OpenAI
import pandas as pd
import numpy as np
from pymongo import MongoClient
import os, sys

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from core.config import get_settings

settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
client = OpenAI(api_key=GPT_API_KEY)

mongo_client = MongoClient(settings.mongo_uri)
db = mongo_client["Apayo"]
collection = db["symptom_embeddings_large"]

# 기존 데이터를 불러옴
df = pd.read_csv("data/normalized_symptoms_diseases.csv", encoding="utf-8-sig")

# 증상 리스트 추출 및 중복 제거
symptoms = df["Symptom"].dropna().unique()


# 증상 임베딩 함수
def get_embedding(text):
    response = client.embeddings.create(input=text, model="text-embedding-3-large")
    return response.data[0].embedding


# 증상 임베딩 및 저장
for symptom in symptoms:
    embedding = get_embedding(symptom)
    related_diseases = df[df["Symptom"] == symptom]["Disease"].values[0].split(", ")
    symptom_data = {
        "symptom": symptom,
        "embedding": embedding,
        "diseases": related_diseases,
    }
    collection.insert_one(symptom_data)
    print(f"Saved embedding for symptom: {symptom}")
print("All embeddings saved to MongoDB")
