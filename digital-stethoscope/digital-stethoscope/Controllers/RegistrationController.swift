//
//  RegistrationController.swift
//  digital-stethoscope
//
//  Controlls calls to backend to hangle authentication, registration and other
//  user-related actions
//  Created by Siya Rajpal on 5/6/25.
//

import FirebaseAuth

/// Registers a new user using Firebase Authentication and then sends the user info to your backend.
/// - Parameter user: A `UserProfile` object containing registration details (email, password, etc.)
/// - Returns: A tuple with a status message and success flag.
func authRegister(user: UserProfile) async -> (String, Bool) {
    do {
        // Create a new user account with Firebase Authentication and gets token
        let authResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        let token = try await authResult.user.getIDTokenResult().token

        // Send the token and user info to your backend to complete registration
        let (message, success) = try await registerUser(token: token, user: user)
        return (message, success)
    } catch {
        // Handle any errors from Firebase or backend registration
        print("Error in Firebase Auth createUser:", error.localizedDescription)
        return (error.localizedDescription, false)
    }
}

/// Sends the user's information to your backend to complete the registration process.
/// - Parameters:
///   - token: A valid Firebase auth token.
///   - user: A `UserProfile` object containing the user's details.
/// - Returns: A tuple with a status message and success flag.
/// - Throws: Can throw if JSON serialization or network request fails.
func registerUser(token: String, user: UserProfile) async throws -> (String, Bool) {
    // Construct the registration endpoint URL
    guard let url = URL(string: APIConfig.registerEndpoint) else {
        return ("Invalid URL", false)
    }

    // Set up the HTTP POST request with necessary headers
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    // Construct the request body from the UserProfile object
    let body: [String: Any] = [
        "email": user.email,
        "firstName": user.firstName,
        "timeZone": user.timeZone,
        "deviceIDs": user.deviceIds,
        "deviceNicknames": user.deviceNicknames,
        "currentDeviceID": user.currentDeviceID,
    ]

    // Serialize the request body to JSON data
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    do {
        // Send the request and await the response
        let (_, response) = try await URLSession.shared.data(for: request)

        // error check: ensure correct status code returned
        if let httpResponse = response as? HTTPURLResponse {
            if (200 ... 299).contains(httpResponse.statusCode) {
                return ("Registration successful", true)
            } else {
                return ("Server responded with status code \(httpResponse.statusCode)", false)
            }
        } else {
            return ("Invalid HTTP response", false)
        }
    } catch {
        return ("Network error: \(error.localizedDescription)", false)
    }
}
