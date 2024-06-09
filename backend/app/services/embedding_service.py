import openai
import pandas as pd
import numpy as np
from pymongo import MongoClient
import sys, os
from sklearn.metrics.pairwise import cosine_similarity

sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from core.config import get_settings

# 환경 설정 로드
settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
openai.api_key = GPT_API_KEY

# MongoDB 클라이언트 설정
mongo_client = MongoClient(settings.mongo_uri)
db = mongo_client["Apayo"]
collection = db["symptom_embeddings_large"]

# 기존 데이터를 불러옴
df = pd.read_csv("data/normalized_symptoms_diseases.csv", encoding="utf-8-sig")


def get_embedding(text):
    response = openai.embeddings.create(input=[text], model="text-embedding-3-large")
    embedding_data = response.data[0].embedding
    return np.array(embedding_data)


def find_similar_symptoms(new_symptoms):
    # 새로운 증상 임베딩
    new_embeddings = [get_embedding(symptom) for symptom in new_symptoms]

    # MongoDB에서 임베딩 데이터 가져오기
    db_embeddings = list(
        collection.find({}, {"_id": 0, "embedding": 1, "symptom": 1, "diseases": 1})
    )

    # 유사도 계산 및 가장 유사한 증상 찾기
    top_similarities = []
    for new_embedding in new_embeddings:
        similarities = []
        for entry in db_embeddings:
            db_embedding = entry["embedding"]
            similarity = cosine_similarity([new_embedding], [db_embedding])[0][0]
            similarities.append((similarity, entry["symptom"], entry["diseases"]))

        # 유사도 상위 3개의 증상 및 질병 쌍 반환
        top_similarities.append(sorted(similarities, reverse=True)[:3])

    # 공통 질병 추출
    common_diseases = set(top_similarities[0][0][2])
    for similarities in top_similarities[1:]:
        current_diseases = set()
        for _, _, diseases in similarities:
            current_diseases.update(diseases)
        common_diseases.intersection_update(current_diseases)

    # 결과를 딕셔너리 형태로 반환
    result = {
        "input_symptoms": new_symptoms,
        "similar_symptoms": [
            {
                "input_symptom": new_symptoms[i],
                "top_similarities": [
                    {
                        "similar_symptom": sim[1],
                        "similarity": sim[0],
                        "diseases": sim[2],
                    }
                    for sim in top_similarities[i]
                ],
            }
            for i in range(len(new_symptoms))
        ],
        "common_diseases": list(common_diseases),
    }
    return result
