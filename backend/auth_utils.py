'''Token verification'''

from fastapi import Request, HTTPException
from firebase_admin import auth

def verify_token(request: Request) -> str:
    """
        Verifies token sent to backend by frontend.

        Input:
            Auth request containing current user token.

    """
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing or invalid token")
    curr_token = auth_header.split(" ")[1]

    try:
        decoded_token = auth.verify_id_token(curr_token)
        return decoded_token["uid"]
    except Exception as exc:
        raise HTTPException(status_code=401, detail="Invalid Firebase ID token") from exc
