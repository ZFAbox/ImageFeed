//
//  ImagesListServiceTests.swift
//  ImagesListServiceTests
//
//  Created by Федор Завьялов on 20.04.2024.
//
@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    
    func testExample() throws {
        //Given
        let service = ImageListService()
        //        var imageListServiceObserver: NSObjectProtocol?
        let token = "ArYQmf-6sf7uvU00A-2EalMBPUxod9PGO4D8VIhYjFg"
        let expectation = self.expectation(description: "Wait for Notification")

        NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                        expectation.fulfill()
                    }
        service.fetchPhotoNextPage(token: token)
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(service.photos.count, 10)
        
        
        //            service.fetchPhotoNextPage(token: token) { result in
        //                switch result {
        //                case .success(let data):
        //                    print(data.count)
        //                    XCTAssertEqual(data.count, 10)
        //                    expectation.fulfill()
        //                case.failure(let error):
        //                    XCTFail(error.localizedDescription)
        //                }
        //            }
        //                waitForExpectations(timeout: 2)
    }
}
