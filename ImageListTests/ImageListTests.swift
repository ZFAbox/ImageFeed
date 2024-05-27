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
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! Ima
        let presenter = ImageListPresenterSpy()
        viewController.presenter = presenter
        let imageURLString = "https://paleontol.ru/wp-content/uploads/2021/04/planeta-sputnik-encelad-2048x1739.jpg"
        let url = URL(string: imageURLString)
        
        //then
        viewController.presenter.load
    }
}
