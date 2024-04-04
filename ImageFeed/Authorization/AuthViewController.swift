//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.02.2024.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    //MARK: - Statics
    static var showWebViewSigueIdentifier = "ShowWebView"
    
    //MARK: - Privates
    private let oauth2Service = OAuth2Service.shared
    private let unsplashPostRequestURLString = "https://unsplash.com/oauth/token"
//    private let profile = ProfileService()
    
    //MARK: - Delegate
    var delegate: SplashViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AuthViewController.showWebViewSigueIdentifier {
            guard let webViewController = segue.destination as? WebViewViewController else {
                print("Ошибка назначения делегата WebViewViewController")
                return }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    //MARK: - Class Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Button back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Button back")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code) { result in
            guard let delegate = self.delegate else { return }
                switch result {
                case .success(let token):
                    vc.storage.token = token
                    print(token)
//                    self.profile.prepareProfileModel(token: token)
                    delegate.didAuthenticate(self)
                case .failure(let error) :
                    //Создаем Alert
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: "", preferredStyle: .alert)
                    alert.view.accessibilityIdentifier = "alertId"
                    //Создаем действие для Alert
                    let action = UIAlertAction(title: "Ok", style: .default) { _ in
                        
                        alert.dismiss(animated: true)
                        
                        }
                    alert.addAction(action)
                    
                    vc.present(alert, animated: true, completion: nil)
                    print(error.localizedDescription)
            }
        }
    }
}
