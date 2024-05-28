//
//  ImageListTests.swift
//  ImageListTests
//
//  Created by Fedor on 27.05.2024.
//

@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {

    final class ImageListPresenterSpy: ImageListViewPresenterProtocol {
        
        var isAlertShown: Bool = false
        
        func showError(_ vc: ImageFeed.SingleImageViewController, url: URL) {
            isAlertShown = true
        }
        
        func loadFullSizeImage(on vc: ImageFeed.SingleImageViewController, with url: URL) {
            let imageView = UIImageView()
            UIBlockingProgressHud.show()
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "Image placeholder")) { result in
                UIBlockingProgressHud.dismiss()
                switch result {
                case .success(let imageResult):
                    vc.image = imageResult.image
                case .failure(let error):
                    self.showError(vc, url: url)
                    print(error.localizedDescription)
                }
            }
        }
        
        
    }

    func testShowAlert() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let singleViewController = storyboard.instantiateViewController(withIdentifier: "SingleImageView") as! SingleImageViewController
        let presenter = ImageListPresenterSpy()
        viewController.imageListPresenter = presenter
        let imageURLString = ""
        guard let url = URL(string: imageURLString) else { return }
        
        //when
        viewController.imageListPresenter?.loadFullSizeImage(on: singleViewController, with: url)
        
        //then
        
        XCTAssertTrue(presenter.isAlertShown)
        
    }
    
    
    func testNotShowAlert() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let singleViewController = storyboard.instantiateViewController(withIdentifier: "SingleImageView") as! SingleImageViewController
        let presenter = ImageListPresenterSpy()
        viewController.imageListPresenter = presenter
        let imageURLString = "https://paleontol.ru/wp-content/uploads/2021/04/planeta-sputnik-encelad-2048x1739.jpg"
        guard let url = URL(string: imageURLString) else { return }
        
        //when
        viewController.imageListPresenter?.loadFullSizeImage(on: singleViewController, with: url)
        
        //then
        
        XCTAssertFalse(presenter.isAlertShown)
        
    }
}
