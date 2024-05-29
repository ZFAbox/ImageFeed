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
        XCUIApplication().toolbars.buttons["Done"].tap()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 3))
        passwordTextField.tap()
        passwordTextField.typeText("Mem0ry1986!unsplash")
        XCUIApplication().toolbars.buttons["Done"].tap()
        let button = webView.buttons["Login"]
        button.tap()
        print(app.debugDescription)
        sleep(3)
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 2))
    }

    func testFeed() throws {
        let table = app.tables
        sleep(5)
        
        let cell = table.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = table.children(matching: .cell).element(boundBy: 1)
        sleep(3)
        
        cellToLike.buttons.firstMatch.tap()
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 4))
        cellToLike.buttons.firstMatch.tap()
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 4))
        
        cellToLike.tap()
        sleep(4)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(2)
        let navigationButton = app.buttons["backButton"]
        navigationButton.tap()
        sleep(3)

    }
    
    func testProfile() throws {
        sleep(5)
        let profileView = app.tabBars.buttons.element(boundBy: 1)
        profileView.tap()
        XCTAssertTrue(profileView.waitForExistence(timeout: 3))
        let nameIsExist = app.staticTexts["Fedor Zavyalov"].exists
        XCTAssertTrue(nameIsExist)
        let idIsExist = app.staticTexts["@zfabox"].exists
        XCTAssertTrue(idIsExist)
        let statusIsExist = app.staticTexts["Hello, world!"].exists
        XCTAssertTrue(statusIsExist)
        let exitButton = app.buttons["ExitButton"]
        exitButton.tap()
        sleep(2)
        let alertYesButton = app.alerts["Пока, пока!"].otherElements.buttons["Да"]
        alertYesButton.tap()
        sleep(2)
        let enterButton = app.buttons["Authenticate"].exists
        XCTAssertTrue(enterButton)
        
    }
}
