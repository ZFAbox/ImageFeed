//
//  ImagesListServiceTests.swift
//  ImagesListServiceTests
//
//  Created by Федор Завьялов on 20.04.2024.
//
@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {

    func testExample() {
        let service = ImageListService()
        let storage = OAuth2TokenStorage()
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotoNextPage()
    }
}
