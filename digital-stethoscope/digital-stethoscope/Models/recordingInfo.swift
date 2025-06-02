//
//  recordingInfo.swift
//  digital-stethoscope
//
//  Defines the `RecordingInfo` data model used for representing
//  recording session metadata in the digital stethoscope application.
//  Conforms to `Identifiable`, `Codable`, and `Equatable` for SwiftUI
//  compatibility, serialization, and comparison.
//  Created by Shelby Myrman on 5/20/25.
//
import SwiftUI

/// Represents metadata for a single stethoscope recording session.
struct RecordingInfo: Identifiable, Codable, Equatable {
    let id: String // unique recording ID from database, must be included or it will break
    var deviceID: String = "" // the ID of the device that the recording was taken on
    var notes: String = "" // optional
    let sessionDateTime: Date // date and time of when the recording was taken
    var sessionTitle: String = "" // optional, don't include for new sessions but do include for viewed sessions
    var viewed: Bool // important so that we can mark a session as viewed and send that back to the db
    var wavFileURL: URL? = nil

    // MARK: - Computed Properties

    /// Returns the session's date as a user-friendly string.
    var sessionDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: sessionDateTime)
    }

    /// Returns the session's time as a user-friendly string.
    var sessionTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: sessionDateTime)
    }

    // MARK: - Mock Data

    /// Static helper for generating mock `RecordingInfo` instances for testing or previews.
    static func mock(
        id: String = UUID().uuidString,
        title: String = "Mock Session",
        notes: String = "Test notes",
        viewed: Bool = false,
        date: Date = Date(),
        wavFileURL: URL? = nil
    ) -> RecordingInfo {
        RecordingInfo(
            id: id,
            deviceID: "TestDevice",
            notes: notes,
            sessionDateTime: date,
            sessionTitle: title,
            viewed: viewed,
            wavFileURL: wavFileURL
        )
    }
}
