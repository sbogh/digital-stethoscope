//
//  CreateAccountView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//

// TODO: REGISTER NEW USER IN DB, CHECK DB FOR EMAIL, AUTHENTICATE USER

import SwiftUI

struct CreateAccountView: View {
    // email format validation variables
    @State private var email: String = ""
    @State private var isValidEmail = true

    // password format validation variables
    @State private var password: String = ""
    @State private var isValidPWord = true

    // passwords match validation variables
    @State private var confirmedPw: String = ""
    @State private var pWordsMatch = true

    @State private var validNewAccount = false
    var emptyField: Bool {
        email.isEmpty || password.isEmpty || confirmedPw.isEmpty
    }

    var body: some View {
        VStack(spacing: 5) {
            LoginHeaderView(subtitle: "Sign up below\nto start listening")

            // Create account form
            VStack(spacing: 5) {
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
                            .font(Font.custom("Roboto-Regular", size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }

                // Confirm Password field
                SecureField("Confirm Password", text: $confirmedPw)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .onChange(of: confirmedPw) { _, newPWord in
                        pWordsMatch = validatePasswordsMatch(password: password, confirmedPw: newPWord)
                    }

                // Error message if passwords don't match
                if !pWordsMatch {
                    HStack {
                        Text("Passwords do not match")
                            .font(Font.custom("Roboto-Regular", size: 13))
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
                            .font(Font.custom("Roboto-Regular", size: 13))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }

                // password instructions
                HStack {
                    VStack(spacing: 0) {
                        Text("Your password should include at least:\n\t• 8 or more characters \n\t• A lowercase letter \n\t• An uppercase letter \n\t• A number (0-9) \n\t• A special character")
                            .font(Font.custom("Roboto-Regular", size: 16).weight(.heavy))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.navColor)
            .cornerRadius(20)
            .padding(.horizontal)

            // sign up button
            Button(action: {
                if isValidEmail, isValidPWord, pWordsMatch {
                    validNewAccount = true
                }

            }) {
                Text("Sign Up")
                    .font(Font.custom("Roboto-ExtraBold", size: 22)
                    )
                    .fontWeight(.bold)
                    .frame(width: 206)
                    .padding()
                    .background(Color.CTA1)
                    .foregroundColor(Color.primary)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .navigationDestination(isPresented: $validNewAccount) {
                AccountSetupView()
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

    /// Validates both passwords inputted by user matches
    ///
    /// - Parameters:
    ///   - password: The user's passwrod to validate.
    ///   - confirmedPw: The user's password, reentered.
    /// - Returns: A Boolean value indicating whether input is valid (`true`) or invalid (`false`).
    func validatePasswordsMatch(password: String, confirmedPw: String) -> Bool {
        // Check if password and confirmed password are equal
        if password != confirmedPw {
            return false
        }

        return true
    }
}

#Preview {
    CreateAccountView()
}
