//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Fedor on 27.05.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
        var isAlertShown: Bool = false
        
        func showExitAler(view: ImageFeed.ProfileViewControllerProtocol) {
            isAlertShown = true
        }
    }
    
    func testShowAlert() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        profileViewController.presenter = presenter
        //when
        presenter.showExitAler(view: profileViewController)
        //then
        XCTAssertTrue(presenter.isAlertShown)
    }
    
}
