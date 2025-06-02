//
//  CreateAccountView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//
//  Handles account creation in the digital stethoscope app.
//  Users input their email, password, and confirmation password.
//  Performs validation for email format, password strength, and password matching,
//  then proceeds to the account setup view upon successful input.
//
import SwiftUI

// MARK: - CreateAccountView

/// A SwiftUI view that allows users to create an account by entering their email and password.
/// Validates input fields and navigates to `AccountSetupView` if all inputs are valid.

struct CreateAccountView: View {
    // MARK: - Environment and State

    /// Shared user profile object containing account info
    @EnvironmentObject var userProfile: UserProfile

    /// Email format validation flag
    @State private var isValidEmail = true

    /// Password format validation flag
    @State private var isValidPWord = true

    /// Password confirmation input
    @State private var confirmedPw: String = ""

    /// Password match validation flag
    @State private var pWordsMatch = true

    /// Checks if any of the required fields are empty
    var emptyField: Bool {
        userProfile.email.isEmpty || userProfile.password.isEmpty || confirmedPw.isEmpty
    }

    /// Navigation trigger to continue signup
    @State private var continueSignup = false

    @State private var navLearnMore = false // Tracks whether to navigate to Learn More page

    // MARK: - View Body

    var body: some View {
        VStack(spacing: 5) {
            // Branding header
            LoginHeaderView(subtitle: "Sign up below\nto start listening")
                .padding(.bottom)

            // MARK: - Form Inputs

            VStack(spacing: 5) {
                // Email text field
                TextField("Email", text: $userProfile.email)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
                    .accessibilityIdentifier("CAEmail")
                    .onChange(of: userProfile.email) { _, newEmail in
                        isValidEmail = validateEmail(email: newEmail)
                    }

                // Password input (SecureField or TextField for testing)
                if isUITestMode() {
                    TextField("Password", text: $userProfile.password)
                        .accessibilityIdentifier("CAPassword")
                        .textContentType(.none)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
                        .onChange(of: userProfile.password) { _, newPWord in
                            isValidPWord = validatePassword(password: newPWord)
                        }
                } else {
                    SecureField("Password", text: $userProfile.password)
                        .padding()
                        .textContentType(isUITestMode() ? .none : .password)
                        .autocorrectionDisabled(isUITestMode())
                        .background(Color.primary)
                        .cornerRadius(10)
                        .accessibilityIdentifier("CAPassword")
                        .onChange(of: userProfile.password) { _, newPWord in
                            isValidPWord = validatePassword(password: newPWord)
                        }
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
                if isUITestMode() {
                    TextField("Confirm Password", text: $confirmedPw)
                        .accessibilityIdentifier("CAConfirmPassword")
                        .textContentType(.none)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
                        .onChange(of: confirmedPw) { _, newPWord in
                            pWordsMatch = validatePasswordsMatch(password: userProfile.password, confirmedPw: newPWord)
                        }
                } else {
                    SecureField("Confirm Password", text: $confirmedPw)
                        .padding()
                        .textContentType(isUITestMode() ? .none : .password)
                        .autocorrectionDisabled(isUITestMode())
                        .background(Color.primary)
                        .cornerRadius(10)
                        .accessibilityIdentifier("CAConfirmPassword")
                        .onChange(of: confirmedPw) { _, newPWord in
                            pWordsMatch = validatePasswordsMatch(password: userProfile.password, confirmedPw: newPWord)
                        }
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

            // MARK: - Sign Up Button

            Button(action: {
                // Proceed if all validations pass
                if isValidEmail, isValidPWord, pWordsMatch, !emptyField {
                    continueSignup = true
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
            .accessibilityIdentifier("SignupButton")
            .navigationDestination(isPresented: $continueSignup) {
                AccountSetupView().environmentObject(userProfile)
            }

            // MARK: - Learn More Link

            Button(action: {
                navLearnMore = true
            }) {
                Text("Learn More")
                    .font(Font.custom("Roboto-ExtraBold", size: 18)
                    )
                    .fontWeight(.bold)
                    .foregroundColor(Color.CTA1)
                    .underline(true, color: .CTA1)
            }.padding(.bottom)
                .navigationDestination(isPresented: $navLearnMore) {
                    LearnMore()
                }
        }
        Spacer() // Push content to top
    }

    // MARK: - Validation Helpers

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

// MARK: - Preview

#Preview {
    CreateAccountView().environmentObject(UserProfile())
}
