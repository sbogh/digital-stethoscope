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
    // handles changes in name
    @State private var name: String = ""
    var nameEmpty: Bool {
        name.isEmpty
    }

    // handles changes in provider ID
    @State private var providerID: String = ""

    // TODO: We don't need PDT and PST, MST and MDT etc, we should choose based on time of year
    // handles time zone inputs
    var timeZones = ["PDT", "PST", "MST", "MDT", "CST", "CDT", "EST", "EDT", "HST", "HDT", "AKST", "AKDT"]
    @State private var selectedZone = ""
    var zoneEmpty: Bool {
        selectedZone.isEmpty
    }

    // determines if user can move to next page
    @State private var cont = false

    var body: some View {
        VStack(spacing: 5) {
            LoginHeaderView(subtitle: "Don’t miss a beat.")

            // Account Info form
            VStack(spacing: 10) {
                // Name text field
                TextField("Name", text: $name)
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
                            selectedZone = timezone
                        }) {
                            Text(timezone)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedZone.isEmpty ? "Timezone" : selectedZone)
                            .foregroundColor(selectedZone.isEmpty ? .gray : .black)
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

                // Provider ID text field
                TextField("ProviderID", text: $providerID)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .padding()
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)

            // continue button
            Button(action: {
                if !nameEmpty, !zoneEmpty {
                    cont = true
                }

                // TODO: add check for provider ID if present

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
            // TODO: route to correct page
            // if providerID provided to DeviceQView, if not then straight to the addDeviceView
            .navigationDestination(isPresented: $cont) {
                LandingPage()
            }
        }
        Spacer()
    }
}

#Preview {
    AccountSetupView()
}
