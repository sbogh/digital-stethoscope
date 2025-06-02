//
//  DeviceQView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/29/25.
//  [NOT CURRENTLY IN USE] Asks the user whether they already own a ScopeFace device.
//  If they do, they are routed to the device registration screen.
//  If they don't, the app proceeds to register the user without device info
//  and displays appropriate loading/error feedback.
//

import SwiftUI

// MARK: - DeviceQView

/// A SwiftUI view that prompts the user to confirm whether they own a ScopeFace device.
/// Based on their response, the user is either taken to device registration or continues without it.

// MARK: - State and Environment

struct DeviceQView: View {
    @State private var devPresent = false // Whether the user has a device
    @EnvironmentObject var userProfile: UserProfile // Shared user data
    @State private var errorMessage = "" // Error message shown if registration fails
    @State private var querySuccess = false // Tracks if registration was successful
    @State private var buttonClicked = false // Prevents duplicate submission
    @State private var isLoading = false // Controls loading spinner

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 5) {
            // Page header
            LoginHeaderView(subtitle: "Do you have\na ScopeFace device?")
                .padding(.bottom)

            // MARK: - "Yes" Button

            // If user has a device, move to device registration screen
            Button(action: {
                devPresent = true
            }) {
                Text("Yes")
                    .font(Font.custom("Roboto-ExtraBold", size: 20)
                    )
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 206, height: 50)
                    .background(Color.CTA1)
                    .cornerRadius(10)
            }.padding()
        }

        // Navigation triggered if user indicates they have a device
        .navigationDestination(isPresented: $devPresent) {
            RegisterDeviceView().environmentObject(userProfile)
        }

        // MARK: - "No" Button

        // If user does not have a device, initiate account registration
        Button(action: {
            buttonClicked = true
            isLoading = true

            Task {
                let (message, success) = await authRegister(user: userProfile)

                if success {
                    querySuccess = true
                    isLoading = false
                } else {
                    querySuccess = false
                    errorMessage = message
                    isLoading = false
                }
            }

        }) {
            Text("No")
                .font(Font.custom("Roboto-ExtraBold", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.CTA1)
                .padding()
                .frame(width: 206, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.CTA1, lineWidth: 4)
                )
        }.padding(.bottom)
            // Navigation triggered if registration succeeds
            .navigationDestination(isPresented: $querySuccess) {
                Activity()
            }

        // TODO: do we want to just get rid of the device q portion and go straight to device selection? otherwise we'll have to add the acct setup pg

        // MARK: - Loading Indicator

        if isLoading {
            ProgressView("Please wait while your account is being created...")
                .padding()
        }

        // MARK: - Error Display

        if !querySuccess, buttonClicked, !isLoading {
            HStack {
                Text("Oops! Something went wrong. Error: \(errorMessage)")
                    .font(Font.custom("Roboto-Regular", size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }

        Spacer() // Pushes content to top
    }
}

// MARK: - Preview

#Preview {
    DeviceQView().environmentObject(UserProfile())
}
