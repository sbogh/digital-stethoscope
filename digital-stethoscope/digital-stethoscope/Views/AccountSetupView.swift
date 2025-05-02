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
    @StateObject var userProfile = UserProfile()

    // handles changes in name
    var nameEmpty: Bool {
        userProfile.firstName.isEmpty
    }

    // handles time zone inputs
    var timeZones = ["PDT", "PST", "MST", "MDT", "CST", "CDT", "EST", "EDT", "HST", "HDT", "AKST", "AKDT"]
    var zoneEmpty: Bool {
        userProfile.timeZone.isEmpty
    }

    // determines if user can move to next page
    @State private var cont = false

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

            // Welcome message
            Text("Welcome to your new account!")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // Account Info form
            VStack(spacing: 10) {
                // Name text field
                TextField("Name", text: $userProfile.firstName)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)

                // Error handling for name
                if nameEmpty {
                    HStack {
                        Text("Name is required")
                            .font(Font.custom("Roboto-Regular", size: 12))
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

                // Error handling for time zone
                if zoneEmpty {
                    HStack {
                        Text("Time Zone is required")
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
            .padding(.bottom)
            // route to next page, provided all info inputted
            .navigationDestination(isPresented: $cont) {
                DeviceQView()
            }
        }
        Spacer()
    }
}

#Preview {
    AccountSetupView()
}
