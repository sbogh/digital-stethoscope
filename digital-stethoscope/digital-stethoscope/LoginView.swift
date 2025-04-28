//
//  LoginView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            //Small Logo at Top
            Image("Logo")
                .resizable()
                .frame(width: 62.46876, height: 87 ,alignment: .top)
            
            //App Name
            Text("ScopeFace")
              .font(
                Font.custom("Roboto", size: 50)
                  .weight(.heavy)
              )
              .multilineTextAlignment(.center)
              .foregroundColor(Color.CTA2)
              .frame(width: 248, height: 60, alignment: .top)
            
            //Log in message
            Text("Log in below. Sound decisions await!")
              .font(Font.custom("Roboto", size: 25))
              .multilineTextAlignment(.center)
              .foregroundColor(Color.CTA2)
              .lineLimit(nil)
            
            // VStack = form itself
            VStack(spacing: 15) {
                
                //Email text field
                TextField("Email", text: $email)
                .padding()
                .background(Color.primary)
                .cornerRadius(10)
                
                
                // Password field
                SecureField("Password", text: $password)
                .padding()
                .background(Color.primary)
                .cornerRadius(10)
                
                
                // forgot password button
                HStack {
                    Spacer()
                    Button(action: {
                        // TODO: forgot password action
                    }) {
                    Text("Forgot password?")
                    .font(.footnote)
                    .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)
            
            //login button
            Button(action: {
                // TODO: add login actions
            }) {
                Text("Log In")
                    .font(Font.custom("Roboto-ExtraBold", size: 22)
                    )
                    .fontWeight(.bold)
                    .frame(width: 206)
                    .padding()
                    .background(Color.CTA1)
                    .foregroundColor(Color.primary)
                    .cornerRadius(10)
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
        Spacer()
    }
}

#Preview {
    LoginView()
}
