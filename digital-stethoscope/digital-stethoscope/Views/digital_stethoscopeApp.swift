//
//  digital_stethoscopeApp.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/18/25.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
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

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LandingPage()
            }
        }
    }
}
