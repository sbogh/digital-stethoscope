//
//  APIConfig.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/2/25.
//

import Foundation

enum APIConfig {
    static let baseURL = "http://127.0.0.1:8000"
    static let registerEndpoint = "\(baseURL)/register"
    static let loginEndpoint = "\(baseURL)/login"
    static let deviceUpdateEndpoint = "\(baseURL)/user/update-device"
}
