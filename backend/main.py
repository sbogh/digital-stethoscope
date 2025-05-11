"""
main.py

Minimal FastAPI backend server with a /ping route used
to verify that the server is running and accepting requests.
Includes CORS middleware for cross-origin frontend access.
"""

from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from auth_utils import verify_token
import user_routes as user_routes

# Create a new FastAPI application instance
app = FastAPI()

# Add middleware to handle Cross-Origin Resource Sharing (CORS)
# This allows the frontend (e.g., iOS Swift app) to make requests to this backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # Allow all origins (safe for dev only)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/register")

async def register_user(request: Request):
    """
    Registers a new user in Firestore using the provided data and Firebase Auth token.

    Input:
    - Firebase ID token in the Authorization header
    - JSON body with all required fields.

    Returns:
        200 OK with confirmation message if successful,
        or an error dict if fields are missing.
    """
    user_id = verify_token(request)
    body = await request.json()


    required_fields = ["email", "firstName", "timeZone"]
    missing_field = []
    for field in required_fields:
        if field not in body:
            missing_field.append(field)
    if missing_field:
        return {"error": f"Missing required fields: {missing_field}"}

    body.setdefault("deviceIDs", [])
    body.setdefault("deviceNicknames", {})
    body.setdefault("currentDeviceID", "")

    user_routes.create_new_user(user_id=user_id, data=body)
    return {"message": f"User {user_id} registered."}

@app.get("/login")
async def get_profile(request: Request):
    """
    Retrieves the current user's profile from Firestore based on their Firebase Auth token.

    Input:
    - Firebase ID token in the Authorization header
    
    Output:
        200 OK with user profile data as a dictionary,
        or an error if no profile is found.
    """
    uid = verify_token(request)
    profile = user_routes.get_user(uid)
    if not profile:
        return {"error": "Profile not found"}
    return profile

@app.post("/user/update-device")
async def update_device(request: Request):

    """
    Updates the user's currentDeviceID field in Firestore.

    Input:
    - Firebase ID token in the Authorization header
    - JSON body with field: "currentDeviceID"

    Output:
        200 OK with success message if updated,
        or 400 Bad Request if the field is missing.
    """
    uid = verify_token(request)
    body = await request.json()

    if "currentDeviceID" not in body:
        raise HTTPException(status_code=400, detail="Missing currentDeviceID")

    user_routes.update_current_user_device(uid, body["currentDeviceID"])
    return {"message": "Current device updated successfully"}
