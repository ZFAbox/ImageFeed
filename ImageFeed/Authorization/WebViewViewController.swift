//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.02.2024.
//

import Foundation
import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    var delegate: AuthViewController?
    private let splashController = SplashViewController()
    let storage = OAuth2TokenStorage()
    var estimatedProgreeObservation: NSKeyValueObservation?
    private let authViewController = "AuthViewController"
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progreesView: UIProgressView!
    
    enum WebViewConstants {
        static let unsplashAuthirizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        estimatedProgreeObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        loadAuthorizationView()
    }
    
    //MARK: - Class Methods
    private func updateProgress() {
        progreesView.progress = Float(webView.estimatedProgress)
        progreesView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthorizationView(){
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthirizeURLString) else {
            print("Ошибка формирования труктуры URLComponentns")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: Constants.accessKey),
            URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: Constants.redirectURI),
            URLQueryItem(name: URLQueryItemsList.responseType.rawValue, value: "code"),
            URLQueryItem(name: URLQueryItemsList.scope.rawValue, value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            print ("Ошибка формирования URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            guard let delegate else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                delegate.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        guard let delegate else { return }
        delegate.webViewViewControllerDismiss(self)
    }
}


