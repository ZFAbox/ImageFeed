//
//  AuthViewComtroller.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.02.2024.
//

import Foundation
import UIKit

class AuthViewComtroller: UIViewController, WebViewViewControllerDelegate {
    
    private let oAuth2Service = OAuth2Service.shared
    
    private let unsplashPostRequestURLString = "https://unsplash.com/oauth/token"
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    private func makeAuthorizationRequest(code: String) -> URLRequest{
        guard var urlComponents = URLComponents(string: unsplashPostRequestURLString) else {
            preconditionFailure("ошибка формирования строки запроса авторизации")
        }
            urlComponents.queryItems = [
                URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: AccessKey),
                URLQueryItem(name: URLQueryItemsList.clientSecret.rawValue, value: SecretKey),
                URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: RedirectURI),
                URLQueryItem(name: URLQueryItemsList.code.rawValue, value: code)
            ]
            
            guard let url = urlComponents.url else {
                preconditionFailure("Невозможно сформировать ссылку на запрос авторизации")}
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request  
    }
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<OAuthTokenResponseDecoder,Error>) -> Void) {
        
        let request = self.makeAuthorizationRequest(code: code)
        let urlSession = URLSession.shared.data(for: request) { result in
        
            switch result {
            case.success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(OAuthTokenResponseDecoder.self, from: data)
                    handler(.success(decodedData))
                } catch {
                    print("Ошибка декодирования")
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
    }
    
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Button back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Button back")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
}
