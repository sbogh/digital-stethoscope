"""
main.py

Minimal FastAPI backend server with a /ping route used
to verify that the server is running and accepting requests.
Includes CORS middleware for cross-origin frontend access.
"""

from fastapi import FastAPI, Request
from auth_utils import verify_token
from fastapi.middleware.cors import CORSMiddleware
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
     user_id = verify_token(request)
     body = await request.json()


     required_fields = ["email", "currentDeviceID", "firstName", "timeZone"]
     missing_field = []
     
     for field in required_fields:
          if field not in body:
              missing_field.push_back(field)
    
     if missing_field:
        return {"error": f"Missing required fields: {missing_field}"}

     body.setdefault("deviceIDs", [])
     body.setdefault("deviceNicknames", [])

     user_routes.create_new_user(user_id=user_id, data=body)
     return {"message": f"User {user_id} registered."}

@app.get("/me")
async def get_profile(request: Request):
    uid = verify_token(request)
    profile = user_routes.get_user(uid)
    if not profile:
        return {"error": "Profile not found"}
    return profile     
