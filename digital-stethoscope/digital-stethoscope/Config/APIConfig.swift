//
//  APIConfig.swift
//  digital-stethoscope
//
//  Defines all the URL's needed to communicate with the backend
//  Created by Siya Rajpal on 5/2/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "http://127.0.0.1:8000"
    static let registerEndpoint = "\(baseURL)/register"
    static let loginEndpoint = "\(baseURL)/login"
    static let deviceUpdateEndpoint = "\(baseURL)/user/update-device"
    static let getRecordingsEndpoint = "\(baseURL)/recordings/compile"
    static let getRecordingsTitleUpdateEndpoint = "\(baseURL)/recordings/update-title"
    static let getRecordingsNoteUpdateEndpoint = "\(baseURL)/recordings/update-notes"
    static let getRecordingsNoteUpdateViewed = "\(baseURL)/recordings/update-view"
}
