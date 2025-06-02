//
//  AccountSetupView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//
//  Handles account setup by allowing the user to enter their name
//  and select a time zone before continuing to the device registration step.
//  Includes input validation
//

import SwiftUI

// MARK: - AccountSetupView

/// A SwiftUI view for setting up user information (name and time zone) after authentication.
/// On valid input, the user is navigated to the device registration view.

struct AccountSetupView: View {
    // MARK: - Environment & State

    /// Shared user profile object for storing name and time zone.
    @EnvironmentObject var userProfile: UserProfile

    /// Boolean indicating whether the name field is empty.
    var nameEmpty: Bool {
        userProfile.firstName.isEmpty
    }

    /// Supported U.S. time zones (daylight savings only; should be seasonal).
    var timeZones = ["PDT", "MDT", "CDT", "EDT", "HDT", "AKDT"]
    /// Boolean indicating whether the time zone field is empty.
    var zoneEmpty: Bool {
        userProfile.timeZone.isEmpty
    }

    /// Controls navigation to the next page.
    @State private var cont = false

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 5) {
            // App branding and page subtitle
            LoginHeaderView(subtitle: "Don’t miss a beat.")
                .padding(.bottom)

            // MARK: - Form Section

            VStack(spacing: 10) {
                // Name text field
                TextField("Name", text: $userProfile.firstName)
                    .padding()
                    .background(Color.primary)
                    .accessibilityLabel("Name")
                    .cornerRadius(10)

                // Inline name validation message
                if nameEmpty {
                    HStack {
                        Text("Name is required")
                            .font(Font.custom("Roboto-Regular", size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }

                // MARK: - Time Zone Picker

                Menu {
                    // Dropdown options for time zones
                    ForEach(timeZones, id: \.self) { timezone in
                        Button(action: {
                            userProfile.timeZone = timezone
                        }) {
                            Text(timezone)
                        }
                    }
                } label: {
                    HStack {
                        Text(userProfile.timeZone.isEmpty ? "Timezone" : userProfile.timeZone)
                            .foregroundColor(userProfile.timeZone.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                }

                // Inline time zone validation message
                if zoneEmpty {
                    HStack {
                        Text("Time Zone is required")
                            .font(Font.custom("Roboto-Regular", size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            }
            .padding()
            .accessibilityIdentifier("TimeZones")
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)

            // MARK: - Continue Button

            Button(action: {
                // Only allow navigation if both fields are filled
                if !nameEmpty, !zoneEmpty {
                    cont = true
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
            .padding()
            .accessibilityIdentifier("ContinueButton")
            // route to next page, provided all info inputted
            .navigationDestination(isPresented: $cont) {
                RegisterDeviceView().environmentObject(userProfile)
            }
        }
        Spacer() // Push content to top
    }
}

// MARK: - Preview

#Preview {
    AccountSetupView().environmentObject(UserProfile())
}
