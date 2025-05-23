//
//  recordingInfo.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/20/25.
//
import SwiftUI

struct RecordingInfo: Identifiable, Codable {
    
    let id: String // unique recording ID from database, must be included or it will break
    var deviceID: String = ""
    var notes: String = "" // optional
    let sessionDateTime: Date // everything works a lot better if we convert this to string on backend and pass in as string here
    var sessionTitle: String = "" // optional, don't include for new sessions but do include for viewed sessions
    var viewed: Bool // important so that we can mark a session as viewed and send that back to the db
    var wavFileURL: URL? =  nil
    
    
    var sessionDate: String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: sessionDateTime)
        }

        var sessionTime: String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: sessionDateTime)
        }
}
