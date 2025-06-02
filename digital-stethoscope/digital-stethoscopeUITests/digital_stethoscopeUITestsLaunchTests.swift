//
//  digital_stethoscopeUITestsLaunchTests.swift
//  digital-stethoscopeUITests
//
//  Created by Siya Rajpal on 4/18/25.
//

import XCTest

/// UI test class for validating the launch screen of the app.
final class digital_stethoscopeUITestsLaunchTests: XCTestCase {
    // MARK: - Class Configuration

    /// Ensures this test case runs for each UI configuration (e.g., light/dark mode).
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    // MARK: - Setup

    /// Called before each test method in the class. Stops execution after the first failure.
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Tests

    /// Tests whether the app launches successfully and captures a screenshot of the initial UI.
    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Take a screenshot of the launch screen
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways

        // Save the screenshot to the test results for inspection
        add(attachment)
    }
}
