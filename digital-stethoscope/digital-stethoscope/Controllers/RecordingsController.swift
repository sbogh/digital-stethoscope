//
//  RecordingsController.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/22/25.
//

import FirebaseAuth

func getFirebaseToken() async throws -> String {
    guard let user = Auth.auth().currentUser else {
        throw NSError(domain: "FirebaseAuth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
    }

    let token = try await user.getIDToken()
    return token
}

func updateRecordingTitle(token: String, recordingID: String, newTitle: String) async -> (String, Bool)  {
    guard let url = URL(string: APIConfig.getRecordingsTitleUpdateEndpoint) else {
        return ("Invalid URL", false)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //print("[UPDATE TITLE] Reqeust values set")

        let body: [String: Any] = [
            "recordingID": recordingID,
            "title": newTitle
        ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //print("[UPDATE TITLE] Request happened")
        
        
        if let httpResponse = response as? HTTPURLResponse {
            if (200...299).contains(httpResponse.statusCode) {
                //print("[UPDATE TITLE] success")
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

func updateRecordingNote(token: String, recordingID: String, newNote: String) async -> (String, Bool)  {
    guard let url = URL(string: APIConfig.getRecordingsNoteUpdateEndpoint) else {
        return ("Invalid URL", false)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //print("[UPDATE TITLE] Reqeust values set")

        let body: [String: Any] = [
            "recordingID": recordingID,
            "note": newNote
        ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //print("[UPDATE NOTE] Request happened")
        
        
        if let httpResponse = response as? HTTPURLResponse {
            if (200...299).contains(httpResponse.statusCode) {
                //print("[UPDATE NOTE] success")
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

func updateRecordingView(token: String, recordingID: String, viewBool: Bool) async -> (String, Bool)  {
    guard let url = URL(string: APIConfig.getRecordingsNoteUpdateViewed) else {
        return ("Invalid URL", false)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    print("[UPDATE VIEW] Reqeust values set")

        let body: [String: Any] = [
            "recordingID": recordingID,
            "view": viewBool
        ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("[UPDATE VIEW] Request happened")
        
        
        if let httpResponse = response as? HTTPURLResponse {
            if (200...299).contains(httpResponse.statusCode) {
                print("[UPDATE VIEW] success")
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

func fetchRecordings(token: String) async -> ([RecordingInfo], String?) {
    guard let url = URL(string: APIConfig.getRecordingsEndpoint) else {
        return ([], "Invalid URL")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    //print("got url and set request method")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //print("set bearer methods")
    
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        //print("got data and response", data)
        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
            //print("response was good")
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let recordings = try decoder.decode([RecordingInfo].self, from: data)
                //print("[FETCH RECORDINGS] Successfully fetched recordings: \(recordings.count)")
                return (recordings, nil)
            }
            
        }
    }
    catch {
        print("Decoding failed:", error)
        print("Raw response:", String(data: try! await URLSession.shared.data(for: request).0, encoding: .utf8) ?? "Unreadable or missing")

        return ([], "Failed to decode recordings: \(error.localizedDescription)")
    }
    
    return ([], "Internal failure")
}

