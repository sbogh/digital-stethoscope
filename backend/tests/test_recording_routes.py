"""
test_recording_routes.py

Tests all recording routes to ensure they exhibit expected behavior.
"""
from unittest.mock import patch, Mock
import sys
import os
import pytest
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


# Mock firestore
mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)


import recording_routes


# mock firebase before each test
@pytest.fixture
def mock_firestore_actions():
    """
    Simulates Firebase interactions in recording routes 

    Output:
        A dictionary containing mocked Firebase objects
            - 'recordings': the patched Firestore recordings collection
            - 'doc': a mocked document reference
            - 'snapshot': a mocked document snapshot
    """
    with patch("recording_routes.recordings") as mock_recordings:
        mock_doc = Mock()
        mock_snapshot = Mock()

        yield {
            "recordings": mock_recordings,
            "doc": mock_doc,
            "snapshot": mock_snapshot
        }


def test_get_unviewed_recordings(mock_firestore_actions):
    """
    Tests that `get_unviewed_recordings` correctly fetches and formats unviewed
    recordings for a given device ID from the mocked Firestore.

    Input:
        mock_firestore_actions (dict): A fixture providing mocked Firestore objects, including
                               the recordings collection and document snapshots.

    Asserts:
        The result is a list of dictionaries, each representing a recording.
    """
    mock_doc = Mock()
    mock_doc.id = "abc123"
    mock_doc.to_dict.return_value = {"deviceID": "deviceXYZ"}
    mock_firestore_actions["recordings"].where.return_value.stream.return_value = [mock_doc]

    result = recording_routes.get_unviewed_recordings("deviceXYZ")
    assert result == [{"deviceID": "deviceXYZ", "id": "abc123"}]

def test_update_recording_title(mock_firestore_actions):
    """
    Tests that `update_recording_title` correctly fetches current recording and 
    updates it for a given device ID from the mocked Firestore.

    Input:
        mock_firestore_actions (dict): A fixture providing mocked Firestore objects, including
                               the recordings collection and document snapshots.

    Asserts:
        The recording's title set to the new title
    """
    mock_snapshot = mock_firestore_actions["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore_actions["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore_actions["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_title("abc123", "New Title")
    mock_doc.update.assert_called_once_with({"sessionTitle": "New Title"})

def test_update_recording_view(mock_firestore_actions):
    """
    Tests that `update_recording_view` correctly fetches current recording and 
    updates it to be viewed.

    Input:
        mock_firestore_actions (dict): A fixture providing mocked Firestore objects, including
                               the recordings collection and document snapshots.

    Asserts:
        The recording's viewed field is set to true
    """
    mock_snapshot = mock_firestore_actions["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore_actions["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore_actions["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_view("abc123", True)
    mock_doc.update.assert_called_once_with({"viewed": True})

def test_update_recording_notes(mock_firestore_actions):
    """
    Tests that `update_recording_note` correctly fetches current recording and 
    updates the note.

    Input:
        mock_firestore_actions (dict): A fixture providing mocked Firestore objects, including
                               the recordings collection and document snapshots.

    Asserts:
        The recording's note set to the new note
    """
    mock_snapshot = mock_firestore_actions["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore_actions["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore_actions["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_notes("abc123", "Updated notes")
    mock_doc.update.assert_called_once_with({"notes": "Updated notes"})
