"""
test_recording_routes.py

Tests all recording routes to ensure they exhibit expected behavior.
"""

from unittest.mock import Mock
import sys
import os
import pytest
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


# Mock firestore
mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)

#import file
import user_routes


#sets up fresh mocks for each test
@pytest.fixture
def mock_firestore_functions():
    """
    Pytest fixture that sets up fresh Firestore mocks for each test.

    Mocks:
        - A user document and snapshot with predefined `to_dict`, `exists`, 
        `get`, `set`, and `update` behaviors.
        - The global `user_routes.users` reference is patched to use the mocked collection.

    Returns:
        dict: A dictionary containing:
            - 'snapshot': Mocked Firestore snapshot
            - 'doc': Mocked Firestore document
            - 'users': Mocked Firestore users collection
    """
    # Set up mocks
    mock_snapshot = Mock()
    mock_snapshot.to_dict.return_value = {"name": "Siya", "currentDeviceID": "deviceXYZ"}
    mock_snapshot.exists = True

    mock_doc = Mock()
    mock_doc.get.return_value = mock_snapshot
    mock_doc.set = Mock()
    mock_doc.update = Mock()

    mock_users = Mock()
    mock_users.document.return_value = mock_doc

    # Patch the actual users object
    user_routes.users = mock_users

    return {
        "snapshot": mock_snapshot,
        "doc": mock_doc,
        "users": mock_users
    }

def test_create_new_user(mock_firestore_functions):
    """
    Tests that `create_new_user` correctly calls `.set()` on the user document
    with the expected data including the user ID.

    Input:
        mock_firestore_functions: Dictionary containing Firestore mocks.
    """
    doc = mock_firestore_functions["doc"]
    user_routes.create_new_user("abc123", {"name": "Siya"})
    doc.set.assert_called_once_with({"name": "Siya", "userID": "abc123"})


def test_get_user_exists(mock_firestore_functions):
    """
    Tests that `get_user` correctly returns user data

    Input:
        mock_firestore_functions: Dictionary containing Firestore mocks.
    """
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = True
    snapshot.to_dict.return_value = {"name": "Siya"}

    result = user_routes.get_user("abc123")
    assert result == {"name": "Siya"}


def test_get_user_not_exists(mock_firestore_functions):
    """
    Tests that `get_user` correctly returns None type if user does not exist

    Input:
        mock_firestore_functions: Dictionary containing Firestore mocks.
    """
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = False

    result = user_routes.get_user("abc123")
    assert result is None


def test_update_current_user_device(mock_firestore_functions):
    """
    Tests that `update_current_user_device` correctly updates the user device 
    in the db

    Input:
        mock_firestore_functions: Dictionary containing Firestore mocks.
    """
    snapshot = mock_firestore_functions["snapshot"]
    doc = mock_firestore_functions["doc"]

    snapshot.exists = True
    doc.update = Mock()

    user_routes.update_current_user_device("abc123", "device123")
    doc.update.assert_called_once_with({"currentDeviceID": "device123"})


def test_get_current_user_device(mock_firestore_functions):
    """
    Tests that `get_current_user_device` correctly returns the user's current
    device from the db

    Input:
        mock_firestore_functions: Dictionary containing Firestore mocks.
    """
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = True
    snapshot.to_dict.return_value = {"currentDeviceID": "deviceXYZ"}

    result = user_routes.get_current_user_device("abc123")
    assert result == "deviceXYZ"
