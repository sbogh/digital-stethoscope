//
//  LandingPageUITests.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/27/25.
//

import XCTest

/// UI tests for verifying that the Landing Page renders correctly and navigates as expected.
final class LandingPageUITests: XCTestCase {
    var app: XCUIApplication!

    // MARK: - Setup

    /// Runs before each test method. Launches the app and prevents test continuation after failure.
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - Tests

    /// Verifies that all major UI elements exist on the Landing Page.
    func testLandingPageElementsExist() {
        XCTAssertTrue(app.staticTexts["LandingTitle"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["LandingTagline"].exists)
        XCTAssertTrue(app.images["LandingLogo"].exists)
        XCTAssertTrue(app.buttons["CreateAccountButton"].exists)
        XCTAssertTrue(app.buttons["LandingLoginButton"].exists)
        XCTAssertTrue(app.buttons["LearnMoreButton"].exists)
    }

    /// Taps the "Log In" button and verifies that the Login View loads by checking for the email field.
    func testNavigateToLoginView() {
        let loginButton = app.buttons["LandingLoginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()

        // Wait for a field from LoginView to confirm successful navigation
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 3))
    }

    /// Taps the "Create Account" button and verifies the CreateAccount View loads by checking for the email field.
    func testNavigateToCreateAccountView() {
        let createButton = app.buttons["CreateAccountButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        createButton.tap()

        // Look for a field in CreateAccountView to confirm successful navigation
        let CAfield = app.textFields["CAEmail"]
        XCTAssertTrue(CAfield.waitForExistence(timeout: 3))
    }

    /// Taps the "Learn More" button and verifies the LearnMore View loads by checking for the title.
    func testNavigateToLearnMoreView() {
        let learnMore = app.buttons["LearnMoreButton"]
        XCTAssertTrue(learnMore.waitForExistence(timeout: 2))
        learnMore.tap()

        // Confirm navigation by checking for a known heading in the LearnMore view
        let heading = app.staticTexts["LearnMoreTitle"]
        XCTAssertTrue(heading.waitForExistence(timeout: 3))
    }
}
