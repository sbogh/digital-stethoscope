//
//  DeviceSelectionView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/11/25.
//

import FirebaseAuth
import SwiftUI

struct DeviceSelectionView: View {
    // current user profile
    @EnvironmentObject var userProfile: UserProfile

    // determines whether to nav to next page
    @State private var cont: Bool = false

    // determines whether user has selected a device
    var noDeviceSelected: Bool {
        userProfile.currentDeviceID.isEmpty
    }

    // manages the button click and API requests
    @State private var errorMessage: String = ""
    @State private var buttonClicked: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            // Small Logo at Top
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

            // add info field
            VStack(spacing: 10) {
                // device drop down: with device nicknames
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

                // Error handling if no device is selected
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

        // continue button
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

        // loading icon when processing backend call
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

    /// Communicates with backend to update user profile with current device
    ///
    /// - Parameters:
    ///   - currentUserDevice: The user's selected device
    /// - Returns: Indicates success or not.
    func updateDevice(currentUserDevice: String) async throws {
        guard let url = URL(string: APIConfig.deviceUpdateEndpoint) else {
            throw URLError(.badURL)
        }

        guard let user = Auth.auth().currentUser else {
            print("No authenticated user.")
            return
        }

        do {
            let token = try await user.getIDToken()
            print("Firebase ID token: \(token)")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: String] = ["currentDeviceID": currentUserDevice]
            request.httpBody = try JSONEncoder().encode(body)

            let (data, response) = try await URLSession.shared.data(for: request)

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

#Preview {
    DeviceSelectionView().environmentObject(UserProfile())
}
