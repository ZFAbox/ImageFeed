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
    private let authViewController = "AuthViewController"
    private var authViewControllerImageView: UIImageView = {
        let authViewControllerImageView = UIImageView()
        authViewControllerImageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Unsplash logo") ?? UIImage()
        authViewControllerImageView.image = image
        return authViewControllerImageView
    }()
    private var authViewControllerButton: UIButton = {
        let authViewControllerButton = UIButton(type: .system)
        authViewControllerButton.tintColor = .ypBlack
        authViewControllerButton.translatesAutoresizingMaskIntoConstraints = false
        authViewControllerButton.setTitle("Войти", for: .normal)
        authViewControllerButton.titleLabel?.font = UIFont(name: "YSDisplay-Bold", size: 17)
        authViewControllerButton.backgroundColor = .ypWhite
        authViewControllerButton.layer.cornerRadius = 16
        authViewControllerButton.clipsToBounds = true
        authViewControllerButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return authViewControllerButton
    } ()
    
    //MARK: - Delegate
    var delegate: SplashViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addSubviews()
        addConstrains()
    }
    

    //MARK: - Class Methods
    private func addSubviews(){
        view.addSubview(authViewControllerImageView)
        view.addSubview(authViewControllerButton)
    }
    
    
    private func addConstrains(){
        addImageViewConstrains()
        addButtonConstrains()
    }
    
    private func addButtonConstrains (){
        NSLayoutConstraint.activate([
            authViewControllerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authViewControllerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authViewControllerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            authViewControllerButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func addImageViewConstrains(){
        NSLayoutConstraint.activate([
            authViewControllerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authViewControllerImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            authViewControllerImageView.heightAnchor.constraint(equalToConstant: 60),
            authViewControllerImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    private func showWebViewController (){
        if let webViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: AuthViewController.showWebViewSigueIdentifier) as? WebViewViewController {
            let webViewPresenter = WebViewPresenter()
            webViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewController
            webViewController.delegate = self
            webViewController.modalPresentationStyle = .fullScreen
            self.present(webViewController, animated: true)
        }
    }
    
    @objc func buttonAction() {
        if let webViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: AuthViewController.showWebViewSigueIdentifier) as? WebViewViewController {
            webViewController.delegate = self
            webViewController.modalPresentationStyle = .fullScreen
            self.present(webViewController, animated: true)
        }
    }
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code) { result in
            guard let delegate = self.delegate else { return }
                switch result {
                case .success(let token):
                    vc.storage.token = token
                    print(token)
                    delegate.didAuthenticate(self)
                case .failure(let error) :
                    self.showAlert(vc)
                    print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDismiss(_ vc: WebViewViewController) {
        let authViewController = AuthViewController()
            authViewController.modalPresentationStyle = .fullScreen
            vc.present(authViewController, animated: true)
    }
    
    private func showAlert(_ vc: WebViewViewController) {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "alertId"

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
            }
        
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func enterButtonDidTapped(_ sender: Any) {
        showWebViewController()
    }
}
