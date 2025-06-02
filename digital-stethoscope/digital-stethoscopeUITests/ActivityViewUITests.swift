//
//  ActivityViewUITests.swift
//  digital-stethoscope
//
//  Created by Siya Rajpal on 5/27/25.
//

import XCTest

extension URL {
    static var testHeartbeatURL: URL? {
        Bundle(for: ActivityViewUITests.self).url(forResource: "frontend-test-heartbeat", withExtension: "wav")
    }
}

final class ActivityViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitest")
        app.launch()

        navigateToActivityView()
    }

    func navigateToActivityView() {
        let caButton = app.buttons["CreateAccountButton"]
        XCTAssertTrue(caButton.waitForExistence(timeout: 5))
        caButton.tap()

        let email = app.textFields["CAEmail"]
        XCTAssertTrue(email.waitForExistence(timeout: 5))
        email.tap()
        email.typeText("valid@email.com")

        let passwordField = app.textFields["CAPassword"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        passwordField.typeText("Abcdef")
        sleep(1)
        passwordField.typeText("!1")

        sleep(1)

        let confirmPassword = app.textFields["CAConfirmPassword"]
        XCTAssertTrue(confirmPassword.waitForExistence(timeout: 5))
        confirmPassword.tap()
        confirmPassword.typeText("Abcdef")
        sleep(1)
        confirmPassword.typeText("!1")

        let signUpButton = app.buttons["SignupButton"]
        XCTAssertTrue(signUpButton.waitForExistence(timeout: 5))
        signUpButton.tap()

        // Confirm you're on AccountSetupView
        let nameField = app.textFields["Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5), "Name field should appear")

        // Type in name
        nameField.tap()
        nameField.typeText("John Doe")

        // Tap the Timezone menu
        let timeZoneMenu = app.buttons["TimeZones"]
        XCTAssertTrue(timeZoneMenu.waitForExistence(timeout: 2))
        timeZoneMenu.tap()

        // Tap on a time zone (e.g., "PDT")
        let pdtButton = app.buttons["PDT"]
        XCTAssertTrue(pdtButton.waitForExistence(timeout: 2), "PDT should appear in menu")
        pdtButton.tap()

        // Tap Continue button
        let continueButton = app.buttons["ContinueButton"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 2))
        continueButton.tap()

        let deviceID = app.textFields["DeviceID"]
        XCTAssertTrue(deviceID.exists)
        deviceID.tap()
        deviceID.typeText("123")

        let deviceName = app.textFields["DeviceName"]
        XCTAssertTrue(deviceName.exists)
        deviceName.tap()
        deviceName.typeText("Stethy's Device")

        let completeButton = app.buttons["SignupCompleteButton"]
        XCTAssertTrue(completeButton.exists)
        completeButton.tap()
    }

//    func testActivityScreenLoadsCorrectly() {
//        // Navigate to Activity if needed (adjust this for your flow)
//
//        app.swipeUp()
//
//        let title = app.staticTexts["ActivityTitle"]
//        XCTAssertTrue(title.waitForExistence(timeout: 3))
//
//        XCTAssertTrue(app.staticTexts["ActivitySubtitle"].exists)
//        XCTAssertTrue(app.images["ActivityLogo"].exists)
//        XCTAssertTrue(app.buttons["LoadSessionsButton"].exists)
//    }

    func testLoadSessionsNavigation() {
        let loadButton = app.buttons["LoadSessionsButton"]
        XCTAssertTrue(loadButton.waitForExistence(timeout: 3))
        loadButton.tap()

        let loadingTitle = app.staticTexts["LoadingTitle"]
        XCTAssertTrue(loadingTitle.waitForExistence(timeout: 3))
    }

    func testOpenRecordingSessionAndPlay() throws {
        // Assumes there is at least one New recording session

        let firstSessionTitle = app.textFields["SessionTitle"]
        XCTAssertTrue(firstSessionTitle.waitForExistence(timeout: 3), "Session Title text field should exist")

        let expandButton = app.buttons["ExpandSessionButton"]
        XCTAssertTrue(expandButton.waitForExistence(timeout: 2))
        expandButton.tap()

        // Check that audio not available message shows up
        let audioPlayer = app.staticTexts["FirebaseAudioPlayer"]
        XCTAssertTrue(audioPlayer.waitForExistence(timeout: 2))
    }

    func testOpenRecordingSessionAndEditNote() throws {
        // Assumes there is at least one New recording session

        let firstSessionTitle = app.textFields["SessionTitle"]
        XCTAssertTrue(firstSessionTitle.waitForExistence(timeout: 3), "Session Title text field should exist")

        let expandButton = app.buttons["ExpandSessionButton"]
        XCTAssertTrue(expandButton.waitForExistence(timeout: 2))
        expandButton.tap()

        // Check that note header is present
        let noteHeader = app.staticTexts["NoteHeader"]
        XCTAssertTrue(noteHeader.waitForExistence(timeout: 2))

        // add note and ensure it renders
        let noteField = app.textViews["NoteField"]
        XCTAssertTrue(noteField.waitForExistence(timeout: 3))

        noteField.tap()
        noteField.typeText("This patient has a murmur. Sad.")
    }

    func testEditRecordingTitle() throws {
        // Assumes there is at least one New recording session

        let firstSessionTitle = app.textFields["SessionTitle"]
        XCTAssertTrue(firstSessionTitle.waitForExistence(timeout: 3), "Session Title text field should exist")

        let sessionTitle = app.textFields["SessionTitle"]
        XCTAssertTrue(sessionTitle.waitForExistence(timeout: 2))

        sessionTitle.tap()
        sessionTitle.typeText("Siya's Heart")
    }
}
