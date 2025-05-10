//
//  LoginHeader.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/10/25.
//

import SwiftUI

struct LoginHeaderView: View {
    var subtitle: String

    var body: some View {
        VStack(spacing: 5) {
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87, alignment: .top)
                .padding(.top)

            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, alignment: .top)

            Text(subtitle)
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)
        }
    }
}
