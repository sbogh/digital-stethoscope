//
//  LoginHeader.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/10/25.
//
//  This reusable SwiftUI view renders the branding header used across login and onboarding screens.
//  It displays the app logo, app name ("ScopeFace"), and a customizable subtitle.
//

import SwiftUI

// MARK: - LoginHeaderView

/// A reusable header view used on authentication and onboarding screens.
/// Displays the ScopeFace logo, app name, and a subtitle passed into the view.
struct LoginHeaderView: View {
    /// The subtitle displayed below the app name.
    var subtitle: String

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 5) {
            // App logo at the top
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87, alignment: .top)
                .padding(.top)

            // App name: ScopeFace
            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, alignment: .top)

            // Subtitle passed into the view
            Text(subtitle)
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)
        }
    }
}
