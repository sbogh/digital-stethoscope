//
//  RegisterDeviceView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/2/25.
//

import FirebaseAuth
import SwiftUI

struct RegisterDeviceView: View {
    // current user profile - with data from past pages saved
    @EnvironmentObject var userProfile: UserProfile

    // device id and name inputted by user
    @State private var deviceID: String = ""

    @State private var deviceName: String = ""

    // checks if fields are left empty
    var emptyField: Bool {
        deviceID.isEmpty || deviceName.isEmpty
    }

    // handles and validates backend call
    @State private var querySuccess = false
    @State private var errorMessage = ""
    @State private var buttonClick = false
    @State private var isLoading = false

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

            // Message
            Text("Great. Let's register your device.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // Device form
            VStack(spacing: 10) {
                // DeviceId text field
                TextField("Device Id", text: $deviceID)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)

                // Device nametext field
                TextField("Device Name", text: $deviceName)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)

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

            // complete sign up button
            Button(action: {
                buttonClick = true
                isLoading = true
                // checks if any fields are empty, & adds devices to user obj
                if !emptyField {
                    addDevices(deviceId: deviceID, deviceName: deviceName)
                }

                // once data validated, register user
                Task {
                    print("calling authRegister with: \(userProfile.email)")
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
            // TODO: route to proper page
            .navigationDestination(isPresented: $querySuccess) {
                PlaceholderView()
            }

            // loading icon when processing sign up
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

    func addDevices(deviceId: String, deviceName: String) {
        print("user email: ", userProfile.email)
        print("user pasword: ", userProfile.password)
        print("user name", userProfile.firstName)
        print("user timezone", userProfile.timeZone)
        let trimmedId = deviceId.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedName = deviceName.trimmingCharacters(in: .whitespacesAndNewlines)

        userProfile.deviceIds.append(trimmedId)
        userProfile.deviceNicknames[trimmedId] = trimmedName

        //print("device registered with id: ", deviceID, "and name: ", deviceName)
    }
}

#Preview {
    RegisterDeviceView().environmentObject(UserProfile())
}
