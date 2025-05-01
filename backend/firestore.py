from firebase_admin import credentials, initialize_app, firestore

cred = credentials.Certificate("backend/config/serviceAccountKey.json")
initialize_app(cred)

db = firestore.client()

doc_ref = db.collection("users").document("V8e2dGZ6HDZuuc6MkRYK")

# Update existing fields or add new ones
doc_ref.update({
    "name": "Updated Name",
    "last_login": "2025-04-29"
})