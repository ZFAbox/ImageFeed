//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Fedor on 27.05.2024.
//

import Foundation
import UIKit

protocol ImageListViewPresenterProtocol {
    
    func showError(_ vc: SingleImageViewController, url: URL)
    func loadFullSizeImage (on vc: SingleImageViewController, with url: URL)
}

final class ImageListViewPresenter: ImageListViewPresenterProtocol {
    
    func showError(_ vc: SingleImageViewController, url: URL) {
        let alert = UIAlertController(title: "Что-то пошло не так. Попробовать еще раз?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let reloadImageAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadFullSizeImage(on: vc, with: url)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(reloadImageAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func loadFullSizeImage (on vc: SingleImageViewController, with url: URL) {
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
