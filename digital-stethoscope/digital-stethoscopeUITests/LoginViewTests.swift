//
//  LoginViewTests.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/27/25.
//

import XCTest

final class LoginViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    /// Navigates from the landing page to the login screen
    func goToLoginScreen() {
        let loginButton = app.buttons["LandingLoginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()
    }

    func testEmptyFieldsError() {
        goToLoginScreen()

        let loginBtn = app.buttons["LogInButton"]
        loginBtn.tap()

        let error = app.staticTexts["EmptyFieldsError"]
        XCTAssertTrue(error.waitForExistence(timeout: 1))
    }

    func testInvalidEmailError() {
        goToLoginScreen()

        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("not-an-email")

        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("ValidPassw0rd!")

        app.buttons["LogInButton"].tap()

        let error = app.staticTexts["InvalidCredentialsError"]
        XCTAssertTrue(error.waitForExistence(timeout: 2))
    }
}
