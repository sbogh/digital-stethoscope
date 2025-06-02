"""Handles Firestore database operations for the backend."""

import os
from firebase_admin import credentials, initialize_app, firestore


os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "config/serviceAccountKey.json"

cred = credentials.Certificate("config/serviceAccountKey.json")
initialize_app(cred)

db = firestore.client()
