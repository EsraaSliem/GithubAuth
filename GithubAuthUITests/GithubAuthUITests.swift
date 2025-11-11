//
//  GithubAuthUITests.swift
//  GithubAuthUITests
//
//  Created by Esraa Sliem on 10/11/2025.
//

import XCTest

final class GithubAuthUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testLoginViewDisplaysSignInButtonWhenSignedOut() throws {
        let signInButton = app.buttons["Sign In with GitHub"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 2))
        XCTAssertTrue(signInButton.isHittable)
    }
}
