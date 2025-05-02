//
//  DeviceQView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/29/25.
//

import SwiftUI

struct DeviceQView: View {
    @State private var devPresent = false

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
            RegisterDeviceView()
        }

        // Do not have a device button
        // TODO: have it go straight to registering a user
        Button(action: {
            // TODO: add code for
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

        Spacer()
    }
}

#Preview {
    DeviceQView()
}
