//
//  DeviceQView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/29/25.
//

import SwiftUI

struct DeviceQView: View {
    var body: some View {
        VStack(spacing: 5) {
            LoginHeaderView(subtitle: "Do you have\na ScopeFace device?")
                .padding(.bottom)

            // Create Account button
            Button(action: {
                // TODO: add code to direct to proper page here
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

        // Log in Button
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
