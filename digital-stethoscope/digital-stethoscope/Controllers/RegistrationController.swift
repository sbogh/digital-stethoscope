//
//  RegistrationController.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/6/25.
//

import FirebaseAuth

func authRegister(user: UserProfile) async -> (String, Bool) {
    do {
        let authResult = try await Auth.auth().createUser(withEmail: user.email, password: user.password)
        let token = try await authResult.user.getIDTokenResult().token

        let (message, success) = try await registerUser(token: token, user: user)
        return (message, success)
    } catch {
        print("Error in Firebase Auth createUser:", error.localizedDescription)
        return (error.localizedDescription, false)
    }
}

func registerUser(token: String, user: UserProfile) async throws -> (String, Bool) {
    guard let url = URL(string: APIConfig.registerEndpoint) else {
        return ("Invalid URL", false)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any] = [
        "email": user.email,
        "firstName": user.firstName,
        "timeZone": user.timeZone,
        "deviceIDs": user.deviceIds,
        "deviceNicknames": user.deviceNicknames,
        "currentDeviceID": "",
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    do {
        let (_, response) = try await URLSession.shared.data(for: request)

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
