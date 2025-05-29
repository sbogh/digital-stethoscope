//
//  LandingPageUITests.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/27/25.
//


import XCTest

final class LandingPageUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLandingPageElementsExist() {
        XCTAssertTrue(app.staticTexts["LandingTitle"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["LandingTagline"].exists)
        XCTAssertTrue(app.images["LandingLogo"].exists)
        XCTAssertTrue(app.buttons["CreateAccountButton"].exists)
        XCTAssertTrue(app.buttons["LandingLoginButton"].exists)
        XCTAssertTrue(app.buttons["LearnMoreButton"].exists)
    }

    func testNavigateToLoginView() {
        let loginButton = app.buttons["LandingLoginButton"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 2))
        loginButton.tap()

        // Wait for LoginView field to appear
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 3))
    }

    func testNavigateToCreateAccountView() {
        let createButton = app.buttons["CreateAccountButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        createButton.tap()

        // Example: Look for a field in CreateAccountView
        let CAfield = app.textFields["CAEmail"]
        XCTAssertTrue(CAfield.waitForExistence(timeout: 3))
    }

    func testNavigateToLearnMoreView() {
        let learnMore = app.buttons["LearnMoreButton"]
        XCTAssertTrue(learnMore.waitForExistence(timeout: 2))
        learnMore.tap()

        // Example: Look for a text heading in LearnMore view
        let heading = app.staticTexts["LearnMoreTitle"]
        XCTAssertTrue(heading.waitForExistence(timeout: 3))
    }
}
