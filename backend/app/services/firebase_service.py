from firebase_admin import firestore
from app.api.schemas.disease_prediction_session import DiseasePredictionSession
from typing import Dict
from datetime import datetime


class SessionManager:
    _sessions_cache = {}
    _db = None

    @staticmethod
    def get_db():
        if SessionManager._db is None:
            SessionManager._db = firestore.client()
        return SessionManager._db

    @staticmethod
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

    @staticmethod
    def get_session(session_id: str) -> DiseasePredictionSession:
        """Retrieve a session from the local cache or Firestore."""
        db = SessionManager.get_db()

        if session_id in SessionManager._sessions_cache:
            return SessionManager._sessions_cache[session_id]

        session_ref = db.collection("disease_prediction_sessions").document(session_id)
        session_data = session_ref.get().to_dict()
        if session_data:
            session = DiseasePredictionSession(**session_data)
            SessionManager._sessions_cache[session_id] = session
            return session
        raise ValueError("Session not found")

    @staticmethod
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

    @staticmethod
    def assign_secondary_symptoms(session_id: str, responses: Dict[str, str]):
        """Assign secondary symptoms to a session and update the session."""
        if session_id in SessionManager._sessions_cache:
            session = SessionManager._sessions_cache[session_id]
            session.assign_secondary_symptoms(responses)
            SessionManager.update_session(
                session_id, {"secondary_symptoms": session.secondary_symptoms}
            )
        else:
            raise ValueError("Session not found")
