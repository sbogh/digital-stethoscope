//
//  LandingPage.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/27/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        // Aligns content in the middle vertically
        VStack(alignment: .center, spacing: 2) {
            // Heading
            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, height: 60, alignment: .top)

            // Tagline
            Text("Don’t miss a beat.")
                .font(Font.custom("Roboto-ExtraBold", size: 22))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 243, height: 35, alignment: .top)

            // Logo
            Image("Logo")
                .frame(width: 135, height: 188)
                .padding(.bottom, 55)

            // Create Account button
            Button(action: {
                // TODO: add route to create account page 1
            }) {
                Text("Create Account")
                    .font(Font.custom("Roboto-ExtraBold", size: 20)
                    )
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 206, height: 50)
                    .background(Color.CTA1)
                    .cornerRadius(10)
            }.padding(.bottom)

            // Log in Button
            Button(action: {
                // TODO: add route to login page 1
            }) {
                Text("Log In")
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

            // Learn More link
            Button(action: {
                // TODO: add route to learn more
            }) {
                Text("Learn More")
                    .font(Font.custom("Roboto-ExtraBold", size: 18)
                    )
                    .fontWeight(.bold)
                    .foregroundColor(Color.CTA1)
                    .underline(true, color: .CTA1)
            }.padding(.bottom)
        }
    }
}

#Preview {
    LoginView()
}
