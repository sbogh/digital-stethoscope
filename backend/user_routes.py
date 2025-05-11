"""
main.py

Defines all routes needed to communicate with Firestore database
"""


from firestore import db

users = db.collection("users")

def create_new_user(user_id: str, data: dict):
    """
        Creates a new user document in the Firestore 'users' collection.

        Input:
            user_id (str): The Firebase UID of the user.
            data (dict): The user data to store. This dictionary is modified to include 'userID'.

    """
    data["userID"] = user_id
    users.document(user_id).set(data)

def get_user(user_id: str):
    """
        Retrieves a user document from the Firestore 'users' collection.

        Input:
            user_id (str): The Firebase UID of the user.

        Returns:
            dict: The user data as a dictionary if the document exists.
            None: If the user document does not exist.
    """
    data = users.document(user_id).get()

    if data.exists:
        return data.to_dict()
    return None

def update_current_user_device(user_id: str, device: str):
    """
        Updates the 'currentDeviceID' field of the specified user's document in Firestore.

        Input:
            user_id (str): The Firebase UID of the user.
            device (str): The new device ID to set as the current device.

    """
    user_reference = users.document(user_id)
    curr_data = user_reference.get()

    if curr_data.exists:
        user_reference.update({"currentDeviceID": device})
