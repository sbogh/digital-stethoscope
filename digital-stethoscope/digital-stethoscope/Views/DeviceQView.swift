//
//  DeviceQView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/29/25.
//

import SwiftUI

struct DeviceQView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            //Small Logo at Top
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87 ,alignment: .top)
            
            //App Name
            Text("ScopeFace")
                .font(
                    Font.custom("Roboto-ExtraBold", size: 40)
                        .weight(.heavy)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .frame(width: 248, height: 60, alignment: .top)
            
            //Welcome message
            //TODO: add personal touch -- user's hospital name
            Text("Do you have a ScopeFace device?")
                .font(Font.custom("Roboto-Regular", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.CTA2)
                .lineLimit(nil)
            
            
            // Create Account button
            Button(action: {
                //TODO: add code to direct to proper page here
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

            // Log in Button
            Button(action: {
                
                //TODO: add code for 
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
