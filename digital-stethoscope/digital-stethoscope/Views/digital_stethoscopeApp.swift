//
//  digital_stethoscopeApp.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/18/25.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

@main
struct digital_stethoscopeApp: App {
    // registers app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // TODO: hi siya I had to comment out the below b/c it was throwing errors
    // let ref = Database.database().reference()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LandingPage()
            }
        }
    }
}
