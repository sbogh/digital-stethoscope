

import pytest
from unittest.mock import Mock, patch
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


# Mock firestore
mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)

#import file
import user_routes


#sets up fresh mocks for each test
@pytest.fixture
def mock_firestore_functions():
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

    # Patch the actual users object used in user_routes
    user_routes.users = mock_users

    return {
        "snapshot": mock_snapshot,
        "doc": mock_doc,
        "users": mock_users
    }

def test_create_new_user(mock_firestore_functions):
    doc = mock_firestore_functions["document"]
    user_routes.create_new_user("abc123", {"name": "Siya"})
    doc.set.assert_called_once_with({"name": "Siya", "userID": "abc123"})


def test_get_user_exists(mock_firestore_functions):
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = True
    snapshot.to_dict.return_value = {"name": "Siya"}

    result = user_routes.get_user("abc123")
    assert result == {"name": "Siya"}


def test_get_user_not_exists(mock_firestore_functions):
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = False

    result = user_routes.get_user("abc123")
    assert result is None


def test_update_current_user_device(mock_firestore_functions):
    snapshot = mock_firestore_functions["snapshot"]
    doc = mock_firestore_functions["document"]

    snapshot.exists = True
    doc.update = Mock()

    user_routes.update_current_user_device("abc123", "device123")
    doc.update.assert_called_once_with({"currentDeviceID": "device123"})


def test_get_current_user_device(mock_firestore_functions):
    snapshot = mock_firestore_functions["snapshot"]
    snapshot.exists = True
    snapshot.to_dict.return_value = {"currentDeviceID": "deviceXYZ"}

    result = user_routes.get_current_user_device("abc123")
    assert result == "deviceXYZ"
