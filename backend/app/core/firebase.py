# firebase_init.py
import base64
import json
from firebase_admin import credentials, initialize_app, auth
from core.config import get_settings

_initialized = False

def initialize_firebase():
    global _initialized
    if not _initialized:
        Settings = get_settings()
        cred = credentials.Certificate(json.loads(base64.b64decode(Settings.google_application_credentials)))
        initialize_app(cred)
        _initialized = True
