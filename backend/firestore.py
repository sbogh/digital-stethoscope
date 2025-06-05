"""Handles Firestore database operations for the backend."""

import os
import firebase_admin
from firebase_admin import credentials, firestore, storage
from urllib.parse import quote

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "config/serviceAccountKey.json"

cred = credentials.Certificate("config/serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'scopeface-10e9a.firebasestorage.app'
})

db = firestore.client()
bucket = storage.bucket()


## TODO: Add the check to see if the object is done processing and only pull if 
## field will be called processed. 
def sync_new_files():
    """
    Syncs new .wav files from Firebase Storage to Firestore.
    """

    # get all files from the recordings folder in Firebase storage
    blobs = list(bucket.list_blobs())
    all_storage_files = [blob.name for blob in blobs if blob.name.endswith(".wav")]

    print(f"Found {len(all_storage_files)} .wav files in Storage.")

    # get recordings in DB
    recordings_ref = db.collection("recordings")
    existing_docs = recordings_ref.stream()
    existing_recordings = set(doc.to_dict().get("file_path") for doc in existing_docs)

    # add files not in db to list
    new_files = [f for f in all_storage_files if f not in existing_recordings]
    print(f"{len(new_files)} new files to add to Firestore.")

    #add to firestore
    for file in new_files:


        blob = bucket.blob(file)


        encoded_path = quote(blob.name, safe='')
        bucket_name = bucket.name
        url = f"https://firebasestorage.googleapis.com/v0/b/{bucket_name}/o/{encoded_path}?alt=media"

        doc_data = {
            'deviceID': "Stethy’s Device",
            'notes': "",
            'sessionDateTime': firestore.SERVER_TIMESTAMP,
            'sessionTitle': "",
            'viewed': False,
            'file_path': file,
            "wavFileURL": url
        }

        db.collection("recordings").add(doc_data)
        print(f"Added Firestore doc for: {file}")
