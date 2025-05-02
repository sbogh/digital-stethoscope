from firestore import db

users = db.collection("users")

def create_new_user(user_id: str, data: dict):
    data["userID"] = user_id
    users.document(user_id).set(data)


def get_user(user_id: str):
    data = users.document(user_id).get()

    if data.exists:
        return data.to_dict()
    
    return None