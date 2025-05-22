"""Handles Firestore database operations for the backend."""


from firebase_admin import credentials, initialize_app, firestore
import os


os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "config/serviceAccountKey.json"

cred = credentials.Certificate("config/serviceAccountKey.json")
initialize_app(cred)

db = firestore.client()
