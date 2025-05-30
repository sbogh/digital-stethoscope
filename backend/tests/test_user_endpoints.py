# test_user_endpoints.py

import pytest
from unittest.mock import patch, Mock
from fastapi.testclient import TestClient
from fastapi import FastAPI
import sys
import os


sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)

from user_endpoints import router

# Set up FastAPI app for testing
app = FastAPI()
app.include_router(router)

@pytest.fixture
def mocked_app():
    return TestClient(app)

@pytest.fixture(autouse=True)
def mock_verify_token():
    with patch("user_endpoints.verify_token", return_value="123456789"):
        yield


@patch("user_endpoints.user_routes.create_new_user")
def test_register_user_success(mock_create_user, mocked_app):
    response = mocked_app.post("/register", json={
        "email": "test@example.com",
        "firstName": "Test",
        "timeZone": "PST"
    })

    assert response.status_code == 200
    assert "message" in response.json()
    mock_create_user.assert_called_once()


def test_register_user_missing_fields(mocked_app):
    response = mocked_app.post("/register", json={
        "email": "test@example.com"
        # missing firstName and timeZone
    })
    assert response.status_code == 200
    assert "error" in response.json()
    assert "Missing required fields" in response.json()["error"]


@patch("user_endpoints.user_routes.get_user", return_value={"email": "test@example.com"})
def test_get_profile_success(mock_get_user, mocked_app):
    response = mocked_app.get("/login")
    assert response.status_code == 200
    assert "email" in response.json()


@patch("user_endpoints.user_routes.get_user", return_value=None)
def test_get_profile_not_found(mock_get_user, mocked_app):
    response = mocked_app.get("/login")
    assert response.status_code == 200
    assert response.json() == {"error": "Profile not found"}


@patch("user_endpoints.user_routes.update_current_user_device")
def test_update_device_success(mock_update_device, mocked_app):
    response = mocked_app.post("/user/update-device", json={
        "currentDeviceID": "device_123"
    })
    assert response.status_code == 200
    assert response.json() == {"message": "Current device updated successfully"}
    mock_update_device.assert_called_once()



def test_update_device_missing_field(mocked_app):
    response = mocked_app.post("/user/update-device", json={})  # No device ID
    assert response.status_code == 400
    assert response.json()["detail"] == "Missing currentDeviceID"
