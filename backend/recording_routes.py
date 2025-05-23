"""
recording_routes.py

Defines all routes needed to communicate with Firestore db recording collection
"""

from firestore import db

recordings = db.collection("recordings")

def get_unviewed_recordings(device_id: str):
    """
    Gets all recordings from Firestore where deviceID matches the given ID.

    Input:
        device_id (str): The device ID tied to the recordings.

    Output:
        List of recordings (as dicts).
    """

    query = recordings.where("deviceID", "==", device_id)
    results = query.stream()
    return  [
        {**doc.to_dict(), "id": doc.id}
        for doc in results 
        ]

def update_recording_title(recording_id: str, new_title: str):
    """
    Given recording id, updates title corresponding to that recording id.

    Input:
        recording_id: The id tied to the recording 
        new_title: The new user inputted title
    """
    recording_ref = recordings.document(recording_id)
    curr_data = recording_ref.get()

    if curr_data.exists:
        recording_ref.update({"sessionTitle": new_title})

def update_recording_view(recording_id: str, viewBool: bool):
    """
    Given recording id, updates viewed to true

    Input:
        recording_id: The id tied to the recording 
    """
    recording_ref = recordings.document(recording_id)
    curr_data = recording_ref.get()

    if curr_data.exists:
        recording_ref.update({"viewed": True})

def update_recording_notes(recording_id: str, new_notes: str):
    """
    Given recording id, updates notes corresponding to that recording id.

    Input:
        recording_id: The id tied to the recording 
        new_notes: The new user inputted title
    """
    recording_ref = recordings.document(recording_id)
    curr_data = recording_ref.get()

    if curr_data.exists:
        recording_ref.update({"notes": new_notes})

