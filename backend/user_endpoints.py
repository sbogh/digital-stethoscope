"""
user_endpoints.py

Defines all fast API routes for all user functions necessary
"""

from fastapi import APIRouter, Request, HTTPException
from auth_utils import verify_token
import user_routes

router = APIRouter()

@router.post("/register")
async def register_user(request: Request):
    """
    Registers a new user in Firestore using the provided data and Firebase Auth token.
    """
    user_id = verify_token(request)
    body = await request.json()

    required_fields = ["email", "firstName", "timeZone"]
    missing_field = [field for field in required_fields if field not in body]

    if missing_field:
        return {"error": f"Missing required fields: {missing_field}"}

    body.setdefault("deviceIDs", [])
    body.setdefault("deviceNicknames", {})
    body.setdefault("currentDeviceID", "")

    user_routes.create_new_user(user_id=user_id, data=body)
    return {"message": f"User {user_id} registered."}


@router.get("/login")
async def get_profile(request: Request):
    """
    Retrieves the current user's profile from Firestore based on their Firebase Auth token.
    """
    uid = verify_token(request)
    profile = user_routes.get_user(uid)
    if not profile:
        return {"error": "Profile not found"}
    return profile


@router.post("/user/update-device")
async def update_device(request: Request):
    """
    Updates the user's currentDeviceID field in Firestore.
    """
    uid = verify_token(request)
    body = await request.json()

    if "currentDeviceID" not in body:
        raise HTTPException(status_code=400, detail="Missing currentDeviceID")

    user_routes.update_current_user_device(uid, body["currentDeviceID"])
    return {"message": "Current device updated successfully"}
