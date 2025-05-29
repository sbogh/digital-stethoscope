//
//  AccountSetupView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//

import SwiftUI

// TODO: Save information and send to DB

// TODO: checking provider ID's - how, REQUIRE ID

struct AccountSetupView: View {
    // user data object
    @EnvironmentObject var userProfile: UserProfile

    // handles changes in name
    var nameEmpty: Bool {
        userProfile.firstName.isEmpty
    }

    // TODO: We don't need PDT and PST, MST and MDT etc, we should choose based on time of year
    // handles time zone inputs
    var timeZones = ["PDT", "MDT","CDT","EDT", "HDT", "AKDT"]
    var zoneEmpty: Bool {
        userProfile.timeZone.isEmpty
    }

    // determines if user can move to next page
    @State private var cont = false

    var body: some View {
        VStack(spacing: 5) {
            LoginHeaderView(subtitle: "Don’t miss a beat.")
                .padding(.bottom)

            // Account Info form
            VStack(spacing: 10) {
                // Name text field
                TextField("Name", text: $userProfile.firstName)
                    .padding()
                    .background(Color.primary)
                    .accessibilityLabel("Name")
                    .cornerRadius(10)

                // Error handling for name
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

                // Time zone drop down
                Menu {
                    ForEach(timeZones, id: \.self) { timezone in
                        Button(action: {
                            userProfile.timeZone = timezone
                        }) {
                            Text(timezone)
                        }
                    }
                }label: {
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

                // Error handling for time zone
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

            // continue button
            Button(action: {
                if !nameEmpty, !zoneEmpty {
                    cont = true
                    // print("going to device page with name: ", userProfile.firstName, "and time zone: ", userProfile.timeZone)
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
        Spacer()
    }
}

#Preview {
    AccountSetupView().environmentObject(UserProfile())
}
