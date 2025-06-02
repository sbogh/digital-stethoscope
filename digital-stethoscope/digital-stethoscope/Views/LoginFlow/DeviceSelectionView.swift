//
//  DeviceSelectionView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/11/25.
//  Allows the user to select their current ScopeFace device
//  from a list of registered devices. Updates the user's profile
//  in the backend with the selected device and navigates to the main activity screen.
//

import FirebaseAuth
import SwiftUI

// MARK: - DeviceSelectionView

/// A SwiftUI view that prompts the user to select their current device and sends that choice to the backend.
/// Once a device is selected and confirmed, the app proceeds to the Activity screen.

struct DeviceSelectionView: View {
    // MARK: - Environment and State

    /// Shared user data
    @EnvironmentObject var userProfile: UserProfile

    /// Triggers navigation to the next page
    @State private var cont: Bool = false

    /// Flag to track if no device has been selected
    var noDeviceSelected: Bool {
        userProfile.currentDeviceID.isEmpty
    }

    /// Backend error message (if any)
    @State private var errorMessage: String = ""
    /// Tracks if the user attempted to proceed
    @State private var buttonClicked: Bool = false
    /// Controls the display of the loading spinner
    @State private var isLoading: Bool = false

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 15) {
            // MARK: - Branding Header

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

            // welcome message
            Text("Welcome, \(userProfile.firstName). Chose your current device to get listening!")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // MARK: - Device Selection Form

            VStack(spacing: 10) {
                // Device dropdown with nicknames
                Menu {
                    ForEach(Array(userProfile.deviceNicknames.values), id: \.self) { device in
                        Button(action: {
                            userProfile.currentDeviceID = device
                        }) {
                            Text(device)
                        }
                    }
                } label: {
                    HStack {
                        Text(userProfile.currentDeviceID.isEmpty ? "Device" : userProfile.currentDeviceID)
                            .foregroundColor(userProfile.currentDeviceID.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Device Dropdown")
                }
                .accessibilityIdentifier("DeviceDropdown")

                /// Inline error message if device not selected
                if noDeviceSelected {
                    HStack {
                        Text("Selecting your current device is required")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            .padding(30)
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)
        }

        // MARK: - Continue Button

        Button(action: {
            if !noDeviceSelected {
                buttonClicked = true
                isLoading = true
                Task {
                    do {
                        try await updateDevice(currentUserDevice: userProfile.currentDeviceID)
                        cont = true
                        isLoading = false
                    } catch {
                        errorMessage = "Error updating device. Please try again"
                        isLoading = false
                    }
                }
            }

        }) {
            Text("Continue")
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
        .accessibilityIdentifier("ContinueButton")
        // route to next page, provided all info inputted
        .navigationDestination(isPresented: $cont) {
            Activity().environmentObject(userProfile)
        }

        // MARK: - Loading and Error State

        if isLoading {
            ProgressView("Updating current device...")
                .padding()
        }

        // error message if issue with the update
        if !cont, buttonClicked, !isLoading {
            HStack {
                Text(errorMessage)
                    .font(Font.custom("Roboto-Regular", size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        Spacer()
    }

    // MARK: - Backend Function

    /// Sends a request to the backend to update the user's current device ID.
    ///
    /// - Parameter currentUserDevice: The device ID or nickname selected by the user.
    /// - Throws: An error if the network call fails or the server returns an error.
    func updateDevice(currentUserDevice: String) async throws {
        guard let url = URL(string: APIConfig.deviceUpdateEndpoint) else {
            throw URLError(.badURL)
        }

        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }

        do {
            // Retrieve Firebase auth token
            let token = try await user.getIDToken()
            print("Firebase ID token: \(token)")

            // Construct request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // JSON body
            let body: [String: String] = ["currentDeviceID": currentUserDevice]
            request.httpBody = try JSONEncoder().encode(body)

            // Send request
            let (data, response) = try await URLSession.shared.data(for: request)

            // Validate server response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            if (200 ... 299).contains(httpResponse.statusCode) {
                print("Device updated successfully")
            } else {
                let serverMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw NSError(domain: "Server", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: serverMessage])
            }
        } catch {
            print("Failed to get Auth token:", error.localizedDescription)
        }
    }
}

// MARK: - Preview

#Preview {
    DeviceSelectionView().environmentObject(UserProfile())
}
