//
//  DeviceQView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/29/25.
//

import SwiftUI

struct DeviceQView: View {
    @State private var devPresent = false
    
    @EnvironmentObject var userProfile: UserProfile
    
    @State private var errorMessage = ""
    @State private var querySuccess = false
    @State private var buttonClicked = false
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
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
            // TODO: add personal touch -- user's hospital name
            Text("Do you have a ScopeFace device?")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)

            // Have a device button
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
            }.padding(.bottom)
        }

        .navigationDestination(isPresented: $devPresent) {
            RegisterDeviceView().environmentObject(userProfile)
        }

        // Do not have a device button
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
        // TODO: route to proper page
        .navigationDestination(isPresented: $querySuccess) {
            PlaceholderView()
        }
        
        // loading icon when processing sign up
        if isLoading {
            ProgressView("Please wait while your account is being created...")
                .padding()
        }
        
        if !querySuccess, buttonClicked, !isLoading  {
            HStack {
                Text("Oops! Something went wrong. Error: \(errorMessage)")
                    .font(Font.custom("Roboto-Regular", size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }

        Spacer()
    }
}

#Preview {
    DeviceQView().environmentObject(UserProfile())
}
