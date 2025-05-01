from firebase_admin import credentials, initialize_app, firestore

cred = credentials.Certificate("backend/config/serviceAccountKey.json")
initialize_app(cred)

db = firestore.client()
