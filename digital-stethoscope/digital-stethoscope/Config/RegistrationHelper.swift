//
//  SignUpHelper.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/6/25.
//

import FirebaseAuth


func auth_user(user: UserProfile) -> (String, Bool) {
    var errorMessage = ""
    var querySuccess = true
    Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
        if let error = error {
            print("Error in Firebase Auth createUser:", error.localizedDescription)
            errorMessage = error.localizedDescription
            querySuccess = false
            return
        }

        authResult?.user.getIDToken { token, _ in
            if let token = token {
                register_user(token: token, user: user)
                querySuccess = true
            } else {
                print("Token was nil despite no error")
                errorMessage = "Registration Error Occured"
            }
            
        }
    }
    return (errorMessage, querySuccess)
}

func register_user(token: String, user: UserProfile) {
    guard let url = URL(string: APIConfig.registerEndpoint) else { return }
    
    
    var request = URLRequest(url: url)
    
    print("token: ", token)
    
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: Any] = [
        "email": user.email,
        "firstName": user.firstName,
        "timeZone": user.timeZone,
        "deviceIDs": user.deviceIds,
        "deviceNicknames": user.deviceNicknames,
        "currentDeviceID": ""
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request).resume()
}
