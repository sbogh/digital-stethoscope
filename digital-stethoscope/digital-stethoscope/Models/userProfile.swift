//
//  userProfile.swift
//  Persisting data object for user profiles
//  Same as db schema - allows us to keep track of all user data as they create their account
//
//  Created by Siya Rajpal on 5/2/25.
//

import Foundation
import Combine

class UserProfile: ObservableObject {
   
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    @Published var firstName: String = ""
    @Published var timeZone: String = ""
    
    @Published var deviceIds: [String] = []
    @Published var deviceNicknames: [String: String] = [:]
}



