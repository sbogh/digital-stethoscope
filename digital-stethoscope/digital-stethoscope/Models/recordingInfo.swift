//
//  recordingInfo.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//
import SwiftUI

struct RecordingInfo: Identifiable {
    let id: String // unique recording ID from database, must be included or it will break
    let sessionDate: String // everything works a lot better if we convert this to string on backend and pass in as string here
    let sessionTime: String // same as above
    var viewed: Bool // important so that we can mark a session as viewed and send that back to the db
    var sessionTitle: String = "" // optional, don't include for new sessions but do include for viewed sessions
    var notes: String = "" // optional
    var wavFileURL: URL? = nil
}
