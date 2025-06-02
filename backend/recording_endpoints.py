"""
recording_routes.py

Defines all fast API routes for all recording functions necessary
"""

from fastapi import APIRouter, Request, HTTPException
from auth_utils import verify_token
from user_routes import get_current_user_device
import recording_routes

router = APIRouter()

@router.get("/recordings/compile")
async def get_user_recordings(request: Request):
    """
    Returns a list of recordings tied to the user's current device ID.

    Input:
    - Firebase User ID

    Output:
    - All recordings for the current device
    """

    user_id = verify_token(request)
    device_id = get_current_user_device(user_id)

    print("deviceID: ", device_id)

    if not device_id:
        raise HTTPException(status_code=404, detail="No device set for user.")
    recordings = recording_routes.get_unviewed_recordings(device_id)

    return recordings

@router.put("/recordings/update-title")
async def update_recording_title(request: Request):
    """
    Returns success/failure measure if title was updated or not.

    Input:
    - Firebase user ID
    - New title
    """
    verify_token(request)

    body = await request.json()
    recording_id = body.get("recordingID")
    new_title = body.get("title")

    if not recording_id or not new_title:
        raise HTTPException(status_code=400, detail="Missing recordingID or title")

    recording_routes.update_recording_title(recording_id, new_title)
    return {"message": "Current recording title updated successfully"}

@router.put("/recordings/update-notes")
async def update_recording_notes(request: Request):
    """
    Returns success/failure message if note was updated or not.

    Input:
    - Firebase User ID
    - New note content
    """
    verify_token(request)

    body = await request.json()
    recording_id = body.get("recordingID")
    new_notes = body.get("note")

    if not recording_id or not new_notes:
        raise HTTPException(status_code=400, detail="Missing recordingID or note")
    recording_routes.update_recording_notes(recording_id, new_notes)
    return {"message": "Current recording note updated successfully"}

@router.put("/recordings/update-view")
async def update_recording_view(request: Request):
    """
    Returns success/failure message if viewed bool was updated or not.

    Input:
    - Firebase User ID
    - View Boolean
    """
    verify_token(request)

    body = await request.json()
    recording_id = body.get("recordingID")
    view_bool = body.get("view")

    if not recording_id or not view_bool:
        raise HTTPException(status_code=400, detail="Missing recording ID or view bool")
    recording_routes.update_recording_view(recording_id, view_bool)
    return {"message": "Current recording view boolean updated successfully"}
