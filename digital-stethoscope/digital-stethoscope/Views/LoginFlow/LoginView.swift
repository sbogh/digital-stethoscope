//
//  LoginView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//

// TODO: Alter existing functions to query DB and ensure password is correct

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var isValidEmail = true

    @State private var password: String = ""
    @State private var isValidPWord = true

    var emptyField: Bool {
        email.isEmpty || password.isEmpty
    }

    @State private var validAccount = false

    var body: some View {
        VStack(spacing: 20) {
            LoginHeaderView(subtitle: "Log in below. Sound decisions await!")

            // VStack = form itself
            VStack(spacing: 15) {
                // Email text field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .onChange(of: email) { _, newEmail in
                        isValidEmail = validateEmail(email: newEmail)
                    }

                // Password field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .onChange(of: password) { _, newPWord in
                        isValidPWord = validatePassword(password: newPWord)
                    }

                // Error message if password/email invalid
                if !isValidEmail || !isValidPWord {
                    HStack {
                        Text("Invalid Email or Password")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }

                // Error message if any field is empty
                if emptyField {
                    HStack {
                        Spacer()
                        Spacer()
                        Text("All fields are required")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }

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

            // login button
            Button(action: {
                if isValidEmail, isValidPWord {
                    validAccount = true
                }
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
                // TODO: change to correct page
                .navigationDestination(isPresented: $validAccount) {
                    LandingPage()
                }

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

    /// Validates user inputs a valid email
    ///
    /// - Parameters:
    ///   - email: The user's email address to validate.
    /// - Returns: A Boolean value indicating whether input is valid (`true`) or invalid (`false`).
    func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        if email == "" {
            return true
        }

        // Check email is in the right format
        if !(NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)) {
            return false
        }
        return true
    }

    // TODO: validate that email not already in use w/ DB

    /// Validates user inputs a valid password
    ///
    /// - Parameters:
    ///   - password: The user's passwrod to validate.
    /// - Returns: A Boolean value indicating whether input is valid (`true`) or invalid (`false`).
    func validatePassword(password: String) -> Bool {
        // Check if password satisfies all conditions

        if password == "" {
            return true
        }

        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$&*()_+=|<>?{}\\[\\]~-]).{8,}$"

        if !(password.count >= 8 && NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)) {
            return false
        }
        return true
    }
}

#Preview {
    LoginView()
}
