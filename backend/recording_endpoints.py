"""
recording_routes.py

Defines all fast API routes for all recording functions necessary
"""

from fastapi import APIRouter, Request, HTTPException
from auth_utils import verify_token
from user_routes import get_current_user_device
import recording_routes 


router = APIRouter()

@router.get("/unviewed_recordings")
async def get_user_recordings(request: Request):
    """
    Returns a list of recordings tied to the user's current device ID.

    Input:
    - Firebase User ID

    Output:
    - All unviewed recordings for the current user
    """

    user_id = verify_token(request)
    device_id = get_current_user_device(user_id)

    if not device_id:
        raise HTTPException(status_code=404, detail="No device set for user.")
    
    recordings = recording_routes.get_unviewed_recordings(device_id)

    return recordings


