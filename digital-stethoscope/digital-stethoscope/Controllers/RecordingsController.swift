//
//  RecordingsController.swift
//  digital-stethoscope
//
//  Controlls calls to the backend for all recording interactions
//  Created by Siya Rajpal on 5/22/25.
//

import FirebaseAuth

/// Retrieves the current Firebase user's ID token asynchronously.
/// - Returns: A valid Firebase ID token as a `String`.
/// - Throws: An error if there is no authenticated user or token retrieval fails.
func getFirebaseToken() async throws -> String {
    guard let user = Auth.auth().currentUser else {
        // Throw an error if the user is not authenticated
        throw NSError(domain: "FirebaseAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
    }

    let token = try await user.getIDToken()
    return token
}

/// Sends a PUT request to update the title of a specific recording.
/// - Parameters:
///   - token: Firebase auth token for authorization.
///   - recordingID: The unique ID of the recording to update.
///   - newTitle: The new title to be set.
/// - Returns: A tuple with a status message and a success flag.
func updateRecordingTitle(token: String, recordingID: String, newTitle: String) async -> (String, Bool) {
    guard let url = URL(string: APIConfig.getRecordingsTitleUpdateEndpoint) else {
        return ("Invalid URL", false)
    }

    // Construct HTTP PUT request
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Request body
    let body: [String: Any] = [
        "recordingID": recordingID,
        "title": newTitle,
    ]

    do {
        // Convert request body to JSON and send request
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        // Cast response to HTTPURLResponse and handle the output
        if let httpResponse = response as? HTTPURLResponse {
            if (200 ... 299).contains(httpResponse.statusCode) {
                return ("Title updated successfully", true)
            } else {
                let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error"
                return ("Server responded with \(httpResponse.statusCode): \(errorResponse)", false)
            }
        } else {
            return ("Invalid response", false)
        }

    } catch {
        return ("Network error: \(error.localizedDescription)", false)
    }
}

/// Sends a PUT request to update the note of a specific recording.
/// - Parameters:
///   - token: Firebase auth token for authorization.
///   - recordingID: The unique ID of the recording to update.
///   - newNote: The new note to be set.
/// - Returns: A tuple with a status message and a success flag.
func updateRecordingNote(token: String, recordingID: String, newNote: String) async -> (String, Bool) {
    guard let url = URL(string: APIConfig.getRecordingsNoteUpdateEndpoint) else {
        return ("Invalid URL", false)
    }

    // Setup HTTP request
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "recordingID": recordingID,
        "note": newNote,
    ]

    do {
        // Convert request body to JSON and send request
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        // Cast response to HTTPURLResponse and handle the output
        if let httpResponse = response as? HTTPURLResponse {
            if (200 ... 299).contains(httpResponse.statusCode) {
                return ("Note updated successfully", true)
            } else {
                let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error"
                return ("Server responded with \(httpResponse.statusCode): \(errorResponse)", false)
            }
        } else {
            return ("Invalid response", false)
        }

    } catch {
        return ("Network error: \(error.localizedDescription)", false)
    }
}

/// Sends a PUT request to update the view status of a specific recording.
/// - Parameters:
///   - token: Firebase auth token for authorization.
///   - recordingID: The unique ID of the recording to update.
///   - viewBool: A Boolean indicating the new viewed status.
/// - Returns: A tuple with a status message and a success flag.
func updateRecordingView(token: String, recordingID: String, viewBool: Bool) async -> (String, Bool) {
    guard let url = URL(string: APIConfig.getRecordingsNoteUpdateViewed) else {
        return ("Invalid URL", false)
    }

    // Setup HTTP PUT request
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    print("[UPDATE VIEW] Reqeust values set")

    let body: [String: Any] = [
        "recordingID": recordingID,
        "view": viewBool,
    ]

    do {
        // Convert request body to JSON and send request
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        // Cast response to HTTPURLResponse and handle the output
        if let httpResponse = response as? HTTPURLResponse {
            if (200 ... 299).contains(httpResponse.statusCode) {
                // print("[UPDATE VIEW] success")
                return ("View updated successfully", true)
            } else {
                let errorResponse = String(data: data, encoding: .utf8) ?? "Unknown error"
                return ("Server responded with \(httpResponse.statusCode): \(errorResponse)", false)
            }
        } else {
            return ("Invalid response", false)
        }

    } catch {
        return ("Network error: \(error.localizedDescription)", false)
    }
}

/// Fetches all recordings for the current user.
/// - Parameter token: Firebase auth token for authorization.
/// - Returns: A tuple containing an array of `RecordingInfo` and an optional error message.
func fetchRecordings(token: String) async -> ([RecordingInfo], String?) {
    guard let url = URL(string: APIConfig.getRecordingsEndpoint) else {
        return ([], "Invalid URL")
    }

    // Setup HTTP GET request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    do {
        // Send request and wait for response
        let (data, response) = try await URLSession.shared.data(for: request)

        // error checking: look for successful status code
        if let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) {
            do {
                // format data to display properly
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                decoder.dateDecodingStrategy = .formatted(formatter)

                let recordings = try decoder.decode([RecordingInfo].self, from: data)
                return (recordings, nil)
            }
        }
    } catch {
        print("Decoding failed:", error)
        await print("Raw response:", String(data: try! URLSession.shared.data(for: request).0, encoding: .utf8) ?? "Unreadable or missing")

        return ([], "Failed to decode recordings: \(error.localizedDescription)")
    }

    return ([], "Internal failure")
}
