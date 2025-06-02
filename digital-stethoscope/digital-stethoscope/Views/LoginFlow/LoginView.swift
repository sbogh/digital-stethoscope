//
//  LoginView.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 4/28/25.
//
//  Allows users to log into their account. Includes real-time validation
//  for email and password, Firebase authentication, and a call to the backend to retrieve
//  user profile data once authenticated.
//

import FirebaseAuth
import SwiftUI

// MARK: - LoginView

/// A SwiftUI view for user login. It validates credentials, authenticates with Firebase,
/// and fetches user profile data from the backend

struct LoginView: View {
    // MARK: - Form State

    @State private var email: String = ""
    @State private var isValidEmail = true

    @State private var password: String = ""
    @State private var isValidPWord = true

    /// Returns `true` if either email or password is empty
    var emptyField: Bool {
        email.isEmpty || password.isEmpty
    }

    // MARK: - Control Flow State

    @State private var validAccount = false // Triggers navigation on successful login
    @State private var buttonClicked = false // Tracks if user has attempted to log in
    @State private var isLoading = false // Controls display of loading spinner
    @State private var errorMessage = "" // Holds error messages

    @EnvironmentObject var userProfile: UserProfile // Shared app-wide user state

    // Temporary model for decoding backend user data
    struct DecodedUserProfile: Codable {
        let email: String
        let firstName: String
        let timeZone: String
        let deviceIDs: [String]
        let deviceNicknames: [String: String]
    }

    @State private var navLearnMore = false // Tracks whether to navigate to Learn More page

    // MARK: - View Body

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // App logo + subtitle
                LoginHeaderView(subtitle: "Log in below.\nSound decisions await!")

                // MARK: - Login Form

                VStack(spacing: 15) {
                    // Email text field
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
                        .accessibilityIdentifier("Email")
                        .onChange(of: email) { _, newEmail in
                            isValidEmail = validateEmail(email: newEmail)
                        }

                    // Password field (text or secure depending on test mode)
                    if isUITestMode() {
                        TextField("Password", text: $password)
                            .accessibilityIdentifier("Password")
                            .textContentType(.none)
                            .autocorrectionDisabled(true)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(10)
                            .onChange(of: password) { _, newPWord in
                                isValidPWord = validatePassword(password: newPWord)
                            }
                    } else {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(10)
                            .accessibilityIdentifier("Password")
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .onChange(of: password) { _, newPWord in
                                isValidPWord = validatePassword(password: newPWord)
                            }
                    }

                    // MARK: - Inline Error Messages

                    // Invalid credentials error message
                    if !isValidEmail || !isValidPWord {
                        HStack {
                            Text("Invalid Email or Password")
                                .font(Font.custom("Roboto-Regular", size: 13))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("InvalidCredentialsError")
                            Spacer()
                        }
                    }

                    // Empty fields error message
                    if emptyField {
                        HStack {
                            Spacer()
                            Spacer()
                            Text("All fields are required")
                                .font(Font.custom("Roboto-Regular", size: 13))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("EmptyFieldsError")
                        }
                    }

                    // forgot password placeholder
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

                // MARK: - Login Button

                Button(action: {
                    // variables to indicate button status
                    buttonClicked = true
                    isLoading = true

                    // checks if email and password are in valid form
                    if isValidEmail, isValidPWord {
                        // Attempt login
                        Task {
                            do {
                                // if autneticateUser is successful, wait for it to finish and set variables accordingly
                                try await authLogin(email: email, password: password, user: userProfile)
                                DispatchQueue.main.async {
                                    validAccount = true
                                    isLoading = false

                                    // print("recieved userProfile: ", userProfile.email)
                                }

                                // if authenticateUser is not successful, set variables accordingly and get the error
                            } catch {
                                DispatchQueue.main.async {
                                    validAccount = false
                                    isLoading = false
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                    // sets isLoading to false b/c no loading to do if email password are invalid
                    else {
                        isLoading = false
                    }

                    // Button Text:
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
                }.padding()
                    .accessibilityIdentifier("LogInButton")
                    .navigationDestination(isPresented: $validAccount) {
                        DeviceSelectionView().environmentObject(userProfile)
                    }

                // MARK: - Feedback (Loading + Errors)

                if isLoading {
                    ProgressView("Logging in...")
                        .padding()
                }

                // error message if issue with log in
                if !validAccount, buttonClicked, !isLoading {
                    HStack {
                        Text("Oops! Something went wrong. Error: \(errorMessage)")
                            .font(Font.custom("Roboto-Regular", size: 12))
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }

                // MARK: - Learn More

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
            Spacer()
        }
    }

    // MARK: - Validation Functions

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

    // MARK: - Firebase & Backend Integration

    /// Authenticates user and grabs user profile by communicating with the backend
    ///
    /// - Parameters:
    ///   - email: The user's email to validate.
    ///   - password: The user's password to validate
    ///   - user: An empty user profile to store user info in
    /// - Returns: Indicates success or not.
    func authLogin(email: String, password: String, user: UserProfile) async throws {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)

        let firebaseUser = authResult.user
        let token = try await firebaseUser.getIDTokenResult().token

        // print("recieved token: ", token)

        try await loginUser(token: token, user: user)
    }

    /// After authentication, communicates with backend to get user data from database
    ///
    /// - Parameters:
    ///   - token: The user's authentication token
    ///   - user: An empty user profile to store user info in
    /// - Returns: Indicates success or not.
    func loginUser(token: String, user: UserProfile) async throws {
        guard let url = URL(string: APIConfig.loginEndpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoded = try JSONDecoder().decode(DecodedUserProfile.self, from: data)

        DispatchQueue.main.async {
            user.email = decoded.email
            user.firstName = decoded.firstName
            user.timeZone = decoded.timeZone
            user.deviceIds = decoded.deviceIDs
            user.deviceNicknames = decoded.deviceNicknames
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView().environmentObject(UserProfile())
}
