//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.02.2024.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    static var showWebViewSigueIdentifier = "ShowWebView"
    private let oAuth2Service = OAuth2Service.shared
    private let unsplashPostRequestURLString = "https://unsplash.com/oauth/token"
    var delegate: SplashViewController?
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
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
    
    
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Button back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Button back")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
}