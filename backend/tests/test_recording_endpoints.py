import pytest
from unittest.mock import patch, Mock
from fastapi.testclient import TestClient
from fastapi import FastAPI
import sys
import os

# Set path to import recording_endpoints properly
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)

from recording_endpoints import router

# FastAPI test app
app = FastAPI()
app.include_router(router)

@pytest.fixture
def mocked_app():
    return TestClient(app)

# Automatically mock verify_token in all tests
@pytest.fixture(autouse=True)
def mock_verify_token():
    with patch("recording_endpoints.verify_token", return_value="test_user_id"):
        yield


@patch("recording_endpoints.get_current_user_device", return_value="device9876")
@patch("recording_endpoints.recording_routes.get_unviewed_recordings", return_value=[{"id": "9876"}])
def test_get_user_recordings_success(mock_get_recordings, mock_get_device, mocked_app):
    response = mocked_app.get("/recordings/compile")
    assert response.status_code == 200
    assert response.json() == [{"id": "9876"}]
    mock_get_recordings.assert_called_once_with("device9876")


@patch("recording_endpoints.recording_routes.update_recording_view")
def test_update_recording_view_success(mock_update_view, mocked_app):
    response = mocked_app.put("/recordings/update-view", json={
        "recordingID": "testRecording",
        "view": True
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Current recording view boolean updated successfully"}
    mock_update_view.assert_called_once_with("testRecording", True)


@patch("recording_endpoints.get_current_user_device", return_value=None)
def test_get_user_recordings_no_device(mock_get_device, mocked_app):
    response = mocked_app.get("/recordings/compile")
    assert response.status_code == 404
    assert response.json()["detail"] == "No device set for user."


def test_update_recording_title_missing_fields(mocked_app):
    response = mocked_app.put("/recordings/update-title", json={
        "recordingID": "testRecording"
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "Missing recordingID or title"


@patch("recording_endpoints.recording_routes.update_recording_title")
def test_update_recording_title_success(mock_update_title, mocked_app):
    response = mocked_app.put("/recordings/update-title", json={
        "recordingID": "testRecording",
        "title": "New Title"
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Current recording title updated successfully"}
    mock_update_title.assert_called_once_with("testRecording", "New Title")



@patch("recording_endpoints.recording_routes.update_recording_notes")
def test_update_recording_notes_success(mock_update_notes, mocked_app):
    response = mocked_app.put("/recordings/update-notes", json={
        "recordingID": "testRecording",
        "note": "Updated notes"
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Current recording note updated successfully"}
    mock_update_notes.assert_called_once_with("testRecording", "Updated notes")


def test_update_recording_notes_missing_fields(mocked_app):
    response = mocked_app.put("/recordings/update-notes", json={
        "note": "Oh no! Something is wrong with this heartbeat"
    })
    assert response.status_code == 400
    assert response.json()["detail"] == "Missing recordingID or note"
