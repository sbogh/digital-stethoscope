# test_recording_routes.py

import pytest
from unittest.mock import patch, Mock
import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


# Mock firestore
mock_firestore = Mock()
sys.modules["firestore"] = Mock(db=mock_firestore)


import recording_routes


# mock firebase before each test
@pytest.fixture
def mock_firestore():
    with patch("recording_routes.recordings") as mock_recordings:
        mock_doc = Mock()
        mock_snapshot = Mock()

        yield {
            "recordings": mock_recordings,
            "doc": mock_doc,
            "snapshot": mock_snapshot
        }


def test_get_unviewed_recordings(mock_firestore):
    mock_doc = Mock()
    mock_doc.id = "abc123"
    mock_doc.to_dict.return_value = {"deviceID": "deviceXYZ"}
    mock_firestore["recordings"].where.return_value.stream.return_value = [mock_doc]

    result = recording_routes.get_unviewed_recordings("deviceXYZ")
    assert result == [{"deviceID": "deviceXYZ", "id": "abc123"}]

def test_update_recording_title(mock_firestore):
    mock_snapshot = mock_firestore["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_title("abc123", "New Title")
    mock_doc.update.assert_called_once_with({"sessionTitle": "New Title"})

def test_update_recording_view(mock_firestore):
    mock_snapshot = mock_firestore["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_view("abc123", True)
    mock_doc.update.assert_called_once_with({"viewed": True})

def test_update_recording_notes(mock_firestore):
    mock_snapshot = mock_firestore["snapshot"]
    mock_snapshot.exists = True

    mock_doc = mock_firestore["doc"]
    mock_doc.get.return_value = mock_snapshot
    mock_firestore["recordings"].document.return_value = mock_doc

    recording_routes.update_recording_notes("abc123", "Updated notes")
    mock_doc.update.assert_called_once_with({"notes": "Updated notes"})