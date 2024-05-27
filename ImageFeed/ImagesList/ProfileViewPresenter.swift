//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Fedor on 27.05.2024.
//

import Foundation
import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    
    func showExitAler(view: ProfileViewControllerProtocol)
    
}


final class ProfileViewPresenter: ProfileViewPresenterProtocol {

    private var storage = OAuth2TokenStorage()
    
    func userLogout() {
        self.storage.removeToken()
        ProfileLogoutService.shared.logout()
    }
    
    func showExitAler(view: ProfileViewControllerProtocol) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else{ return }
            self.userLogout()
            let splashViewController = SplashViewController()
            splashViewController.modalPresentationStyle = .fullScreen
            view.present(splashViewController, animated: true)
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        view.present(alert, animated: true)
    }
    
    
    
    
}
