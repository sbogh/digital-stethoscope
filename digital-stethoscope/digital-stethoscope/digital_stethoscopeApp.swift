//
//  digital_stethoscopeApp.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/18/25.
//
//  Main entry point of the SwiftUI app. Configures Firebase,
//  injects shared app state via UserProfile, and sets the initial view.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

// MARK: - AppDelegate for Firebase Initialization

/// AppDelegate subclass used to configure Firebase when the app launches.
/// Required to integrate Firebase properly in SwiftUI lifecycle.
class AppDelegate: NSObject, UIApplicationDelegate {
    /// Called when the app finishes launching. Initializes Firebase.
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

// MARK: - Main Application Entry Point

@main
struct digital_stethoscopeApp: App {
    /// Connects the AppDelegate for Firebase configuration.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    /// Shared user state across the app.
    @StateObject var userProfile = UserProfile()

    // MARK: - Initialization

    /// App-level initializer. Preloads test data if running in UI test mode.
    init() {
        if ProcessInfo.processInfo.arguments.contains("--uitest") {
            userProfile.firstName = "TestUser"
            userProfile.deviceNicknames = ["abc123": "Stethy's Device", "xyz456": "Test Device B"]
            userProfile.currentDeviceID = "Stethy's Device"
        }
    }

    // MARK: - App Scene Setup

    /// Declares the main UI scene for the app using a NavigationStack.
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LandingPage()
                    .environmentObject(userProfile)
            }
        }
    }
}
