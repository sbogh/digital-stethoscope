//
//  Loading.swift
//  digital-stethoscope
//
//  Created by Shelby Myrman on 5/19/25.
//


// TODO: go to activity screen once recordings are loaded
import SwiftUI

struct Loading: View {
    var body: some View {
        VStack(spacing: 5) {
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87, alignment: .top)

            Text("Listening for new recordings.")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 34)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, alignment: .top)

            Text("Please wait, this can take\n up to 2 minutes.")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)
            
            // TODO: should we leave this spinny thing? i think it looks
            // good but idk if we should choose that or the image
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.secondary))
                  .scaleEffect(2.0, anchor: .center)
                  .padding()
            
            Image("loading")
                .resizable()
                .frame(width: 150,
                       height: 150,
                       alignment: .top)
                .padding(.top)
        }
    }
}

#Preview {
    Loading()
}
