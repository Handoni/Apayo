from pymongo import MongoClient
import numpy as np
from openai import OpenAI
from core.config import get_settings

settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
client = OpenAI(api_key=GPT_API_KEY)

mongo_client = MongoClient(settings.mongo_uri)
db = mongo_client['disease_embedding_db']

def get_embedding(text):
    embedding_data = client.embeddings.create(input=[text], model='text-embedding-3-small').data[0].embedding
    return np.array(embedding_data)

def cosine_similarity(vec1, vec2):
    if np.any(vec1) and np.any(vec2):
        return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))
    return 0

def infer_disease(input_symptom):
    input_embedding = get_embedding(input_symptom)

    # 질병 임베딩과의 유사도 계산
    diseases = db.diseases_embeddings.find()
    similarities = {}
    for disease in diseases:
        disease_embedding = np.array(disease['embedding'])
        similarity = cosine_similarity(input_embedding, disease_embedding)
        similarities[disease['_id']] = similarity

    # 상위 n개의 질병 선별
    top_n_diseases = sorted(similarities.items(), key=lambda x: x[1], reverse=True)[:5]

    # 상세 증상 임베딩과의 유사도 계산
    final_results = {}
    for disease_id, similarity in top_n_diseases:
        final_results[disease_id] = {'similarity': similarity}
        symptoms = db.symptoms.find({'disease_id': disease_id})

        temp = {}
        for symptom in symptoms:
            symptom_embedding = np.array(symptom['embedding'])
            symptom_similarity = cosine_similarity(input_embedding, symptom_embedding)
            temp[symptom['symptom']] = symptom_similarity

        top_n_symptoms = sorted(temp.items(), key=lambda x: x[1], reverse=True)[:5]
        for symptom_id, symptom_similarity in top_n_symptoms:
            final_results[disease_id][symptom_id] = symptom_similarity

    return final_results
