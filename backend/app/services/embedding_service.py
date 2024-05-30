from firebase_admin import firestore
import numpy as np
from openai import OpenAI
from core.config import get_settings
from collections import defaultdict
from core.firebase import initialize_firebase

initialize_firebase()
settings = get_settings()
GPT_API_KEY = settings.gpt_api_key
client = OpenAI(api_key=GPT_API_KEY)

def get_embedding(text):
    embedding_data = client.embeddings.create(input=[text], model='text-embedding-3-small').data[0].embedding
    return np.array(embedding_data)

def cosine_similarity(vec1, vec2):
    if np.any(vec1) and np.any(vec2):
        return np.dot(vec1, vec2) / (np.linalg.norm(vec1) * np.linalg.norm(vec2))
    return 0

def infer_disease(input_symptom):
    input_embedding = get_embedding(input_symptom)
    firestore_client = firestore.client()
    diseases_ref = firestore_client.collection('diseases_embeddings')

    # 질병 임베딩과의 유사도 계산
    diseases = diseases_ref.stream()
    similarities = {}
    for disease in diseases:
        disease_data = disease.to_dict()
        disease_embedding = np.array(disease_data['embedding'])
        similarity = cosine_similarity(input_embedding, disease_embedding)
        similarities[disease.id] = similarity

    # 상위 n개의 질병 선별
    top_n_diseases = sorted(similarities.items(), key=lambda x: x[1], reverse=True)[:5]

    # 상세 증상 임베딩과의 유사도 계산
    final_results = {}
    for disease_id, similarity in top_n_diseases:
        final_results[disease_id] = {}
        final_results[disease_id]['similarity'] = similarity
        symptoms_ref = diseases_ref.document(disease_id).collection('symptoms')
        symptoms = symptoms_ref.stream()
        
        temp = {}
        for symptom in symptoms:
            symptom_data = symptom.to_dict()
            symptom_embedding = np.array(symptom_data['embedding'])
            similarity = cosine_similarity(input_embedding, symptom_embedding)
            temp[symptom.id] = similarity

        top_n_symptoms = sorted(temp.items(), key=lambda x: x[1], reverse=True)[:5]
        for symptom_id, similarity in top_n_symptoms:
            final_results[disease_id][symptom_id] = similarity

    return final_results
