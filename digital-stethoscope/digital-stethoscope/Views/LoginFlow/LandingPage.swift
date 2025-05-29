//
//  LandingPage.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/27/25.
//

import SwiftUI

struct LandingPage: View {
    @State private var navLogin = false
    @State private var navCreateAcc = false

    @State private var navLearnMore = false
    @EnvironmentObject var userProfile: UserProfile

    var body: some View {
        // Aligns content in the middle vertically
        VStack(alignment: .center, spacing: 5) {
            // Heading
            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, alignment: .top)
                .accessibilityIdentifier("LandingTitle")

            // Tagline
            Text("Don’t miss a beat.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 243, height: 35, alignment: .top)
                .accessibilityIdentifier("LandingTagline")

            // Logo
            Image("Logo")
                .frame(width: 135, height: 188)
                .padding(.bottom, 30)
                .accessibilityIdentifier("LandingLogo")

            // Create Account button
            Button(action: {
                navCreateAcc = true
            }) {
                Text("Create Account")
                    .font(Font.custom("Roboto-ExtraBold", size: 20)
                    )
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 206, height: 50)
                    .background(Color.CTA1)
                    .cornerRadius(10)
            }
                .padding(.bottom)
                .accessibilityIdentifier("CreateAccountButton")
                .navigationDestination(isPresented: $navCreateAcc) {
                    CreateAccountView().environmentObject(userProfile)
                }

            // Log in Button
            Button(action: {
                navLogin = true
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
            }
                .padding(.bottom)
                .accessibilityIdentifier("LandingLoginButton")
                .navigationDestination(isPresented: $navLogin) {
                    LoginView().environmentObject(userProfile)
                }

            // Learn More link
            Button(action: {
                navLearnMore = true
            }) {
                Text("Learn More")
                    .font(Font.custom("Roboto-ExtraBold", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.CTA1)
                    .underline(true, color: .CTA1)
            }
            .padding(.bottom)
            .accessibilityIdentifier("LearnMoreButton")
            .navigationDestination(isPresented: $navLearnMore) {
                LearnMore()
            }
        }
    }
}

#Preview {
    LandingPage().environmentObject(UserProfile())
}
