from firebase_admin import firestore
from api.schemas.disease_prediction_session import DiseasePredictionSession
from typing import Dict
from datetime import datetime
from core.firebase import initialize_firebase

initialize_firebase()

class SessionManager:
    _sessions_cache = {}
    _db = None

    def get_db():
        if SessionManager._db is None:
            SessionManager._db = firestore.client()
        return SessionManager._db

    def create_session(user_id: str) -> DiseasePredictionSession:
        """Create a new session and save it to Firestore."""
        db = SessionManager.get_db()

        new_session = DiseasePredictionSession(user_id=user_id)
        session_data = new_session.model_dump()
        session_ref = db.collection("disease_prediction_sessions").document(
            new_session.session_id
        )
        session_ref.set(session_data)
        # Cache the session locally
        SessionManager._sessions_cache[new_session.session_id] = new_session
        return new_session

    def get_session(session_id: str) -> DiseasePredictionSession:
        """Retrieve a session from the local cache or Firestore."""
        db = SessionManager.get_db()

        if session_id in SessionManager._sessions_cache:
            return SessionManager._sessions_cache[session_id]

        session_ref = db.collection("disease_prediction_sessions").document(session_id)
        session_data = session_ref.get().to_dict()
        print(session_data)
        if session_data:
            session = DiseasePredictionSession(**session_data)
            SessionManager._sessions_cache[session_id] = session
            return session
        raise ValueError("Session not found")

    def update_session(session_id: str, updates: Dict[str, any]):
        """Update an existing session both locally and in Firestore using to_firestore_dict."""
        db = SessionManager.get_db()
        session = SessionManager.get_session(session_id)
        if not session:
            raise ValueError("Session not found")

        # Update session with new data provided in updates dictionary
        for key, value in updates.items():
            setattr(session, key, value)

        session.updated_at = datetime.now()

        # Convert the entire session to a dictionary format suitable for Firestore
        updated_session_data = session.model_dump()
        # Update the local cache
        SessionManager._sessions_cache[session_id] = session

        # Update Firestore
        session_ref = db.collection("disease_prediction_sessions").document(session_id)
        session_ref.update(updated_session_data)

