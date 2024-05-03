from firebase_admin import firestore
from app.api.schemas.disease_prediction_session import DiseasePredictionSession
def store_user_session(user_session: DiseasePredictionSession):
    db = firestore.client()

    # Firestore document reference for the session
    session_ref = db.collection('disease_prediction_sessions').document(user_session.session_id)
    
    # Prepare the data to be saved based on the Pydantic models
    session_data = {
        "user_id": user_session.user_id,
        "session_id": user_session.session_id,
        "primary_symptoms": [
            {
                "id": symptom.id,
                "description": symptom.description
            } for symptom in user_session.primary_symptoms
        ],
        "primary_diseases": [
            {
                "code": disease.code,
                "name": disease.name
            } for disease in user_session.primary_diseases
        ],
        "primary_questions": [
            {
                "id": questions.id,
                "disease": {
                    "code": questions.disease.code,
                    "name": questions.disease.name
                },
                "questions": [
                    {
                        "id": question.id,
                        "description": question.description
                    } for question in questions.questions
                ]
            } for questions in user_session.primary_questions
        ]
    }

    # Save the document to Firestore
    session_ref.set(session_data)
    print(f"Session {user_session.session_id} stored in Firestore")
