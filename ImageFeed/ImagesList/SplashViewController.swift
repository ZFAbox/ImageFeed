//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Fedor on 18.03.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {

    let loginSplashViewIdentifier = "LoginSplashViewIdentifier"
    let tapBarViewControllerId = "TapBarViewController"
    
    let storage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            switchToTapBarController()
        } else {
            performSegue(withIdentifier: loginSplashViewIdentifier, sender: nil)
        }
    }
    
    func switchToTapBarController (){
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Неверная настройка")
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tapBarViewControllerId)
        window.rootViewController = tapBarController
    }
}


