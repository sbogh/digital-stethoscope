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

    query = recordings.where("deviceID", "==", device_id).stream()
    return [doc.to_dict() for doc in query]
