//
//  LoginViewTests.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/27/25.
//
//  Contains UI tests for the Login View of the digital-stethoscope app.
//  Checks common error conditions such as empty input and invalid email format.
//  Simulates user interactions to ensure login validation logic works correctly.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!

    // MARK: - Setup

    /// Sets up the XCUIApplication and launches it with UI testing enabled.
    /// Called before each test method is invoked.

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitest")
        app.launch()
    }

    // MARK: - Navigation

    /// Navigates from the Landing Page to the Login View by tapping the login button.
    func goToLoginScreen() {
        let loginButton = app.buttons["LandingLoginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
    }

    // MARK: - Tests

    /// Tests that an error is shown when the login button is tapped with empty email and password fields.
    func testEmptyFieldsError() {
        goToLoginScreen()

        let loginBtn = app.buttons["LogInButton"]
        loginBtn.tap()

        let error = app.staticTexts["EmptyFieldsError"]
        XCTAssertTrue(error.waitForExistence(timeout: 1))
    }

    /// Tests that an error is shown when an invalid email format is entered along with a valid password.
    func testInvalidEmailError() {
        goToLoginScreen()

        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("not-an-email")

        sleep(1)
        app.swipeUp()

        let passwordField = app.textFields["Password"]
        passwordField.tap()
        passwordField.typeText("ValidPassw0rd!")

        app.buttons["LogInButton"].tap()

        let error = app.staticTexts["InvalidCredentialsError"]
        XCTAssertTrue(error.waitForExistence(timeout: 2))
    }
}
