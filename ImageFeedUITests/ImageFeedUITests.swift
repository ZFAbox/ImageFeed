//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Fedor on 28.05.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {

        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 3))
        loginTextField.tap()
        loginTextField.typeText("zfa.box@gmail.com")
        webView.swipeDown()
        XCUIApplication().toolbars.buttons["Done"].tap()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        passwordTextField.tap()
        passwordTextField.typeText("Mem0ry1986!unsplash")
        webView.swipeUp()
        let button = webView.buttons["Login"]
        button.tap()
        print(app.debugDescription)
    
    }

    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }
}
