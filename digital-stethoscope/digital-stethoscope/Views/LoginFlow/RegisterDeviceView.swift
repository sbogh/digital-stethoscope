//
//  RegisterDeviceView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/2/25.
//
//  Allows the user to register a new ScopeFace device during sign-up.
//  Collects the device ID and a user-defined nickname, adds them to the user profile,
//  and then completes account registration by communicating with Firebase and the backend.
//

import FirebaseAuth
import SwiftUI

// MARK: - RegisterDeviceView

/// A SwiftUI view for registering a device during the sign-up process.
/// Users input a device ID and nickname, which are added to their profile.
struct RegisterDeviceView: View {
    // MARK: - Environment and State

    @EnvironmentObject var userProfile: UserProfile // User profile context from previous views

    @State private var deviceID: String = "" // Device ID input
    @State private var deviceName: String = "" // Device nickname input

    /// Determines whether either input field is empty
    var emptyField: Bool {
        deviceID.isEmpty || deviceName.isEmpty
    }

    @State private var querySuccess = false // Flag for successful registration
    @State private var errorMessage = "" // Error message if registration fails
    @State private var buttonClick = false // Tracks whether button was tapped
    @State private var isLoading = false // Shows loading spinner during signup

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 15) {
            // MARK: - Header

            // logo
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87, alignment: .top)

            // App Name
            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, height: 60, alignment: .top)

            // Message
            Text("Great. Let's register your device.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // MARK: - Device Input Form

            VStack(spacing: 10) {
                // DeviceId text field
                TextField("Device Id", text: $deviceID)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .accessibilityLabel("DeviceID")

                // Device nametext field
                TextField("Device Name", text: $deviceName)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .accessibilityLabel("DeviceName")

                // Error message if any field is empty
                if emptyField {
                    HStack {
                        Text("All fields required.")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)

            // MARK: - Complete Sign Up Button

            Button(action: {
                buttonClick = true
                isLoading = true

                // Save device if valid
                if !emptyField {
                    addDevices(deviceId: deviceID, deviceName: deviceName)
                }

                // Trigger Firebase + backend account registration
                Task {
                    if isUITestMode() {
                        await MainActor.run {
                            querySuccess = true
                            isLoading = false
                        }
                    } else {
                        let (message, success) = await authRegister(user: userProfile)
                        await MainActor.run {
                            querySuccess = success
                            errorMessage = message
                            isLoading = false
                        }
                    }
                }

            }) {
                Text("Complete Sign up")
                    .font(Font.custom("Roboto-ExtraBold", size: 22)
                    )
                    .fontWeight(.bold)
                    .frame(width: 206)
                    .padding()
                    .background(Color.CTA1)
                    .foregroundColor(Color.primary)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .accessibilityIdentifier("SignupCompleteButton")
            .navigationDestination(isPresented: $querySuccess) {
                Activity().environmentObject(userProfile)
            }

            // MARK: - Feedback

            if isLoading {
                ProgressView("Please wait while your account is being created...")
                    .padding()
            }

            if !querySuccess, buttonClick, !isLoading {
                HStack {
                    Text("Oops! Something went wrong. Error: \(errorMessage)")
                        .font(Font.custom("Roboto-Regular", size: 12))
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        Spacer()
    }

    // MARK: - Helper Methods

    /// Adds device data to the user's profile before registration.
    ///
    /// - Parameters:
    ///   - deviceId: Raw device ID string entered by user.
    ///   - deviceName: User-chosen nickname for the device.
    func addDevices(deviceId: String, deviceName: String) {
        print("user email: ", userProfile.email)
        print("user pasword: ", userProfile.password)
        print("user name", userProfile.firstName)
        print("user timezone", userProfile.timeZone)
        let trimmedId = deviceId.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = deviceName.trimmingCharacters(in: .whitespacesAndNewlines)

        userProfile.deviceIds.append(trimmedId)
        userProfile.deviceNicknames[trimmedId] = trimmedName
        userProfile.currentDeviceID = trimmedName

        print("device registered with id: ", deviceID, "and name: ", deviceName)
    }
}

// MARK: - Preview

#Preview {
    RegisterDeviceView().environmentObject(UserProfile())
}
