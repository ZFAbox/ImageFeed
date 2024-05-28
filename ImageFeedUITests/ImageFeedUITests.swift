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
        webView.waitForExistence(timeout: 5)
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        loginTextField.typeText("zfa.box@gmail.com")
        passwordTextField.typeText("Mem0ry1986!unsplash")
        webView.swipeUp()
        print(app.debugDescription)
    
    }

    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }
}
