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

    static var sigueIdentifier = "ShowWebView"
    
    var delegate: AuthViewComtroller?
    
    private let storage = OAuth2TokenStorage()
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var progreesView: UIProgressView!
    
    enum WebViewConstants {
        static let unsplashAuthirizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthorizationView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func updateProgress() {
        progreesView.progress = Float(webView.estimatedProgress)
        progreesView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthorizationView(){
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthirizeURLString) else {
            print("Ошибка формирования труктуры URLComponentns")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: AccessKey),
            URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: RedirectURI),
            URLQueryItem(name: URLQueryItemsList.responseType.rawValue, value: "code"),
            URLQueryItem(name: URLQueryItemsList.scope.rawValue, value: AccessScope)
        ]
        guard let url = urlComponents.url else {
            print ("Ошибка формирования URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WebViewViewController.sigueIdentifier {
            guard let viewController = segue.source as? AuthViewComtroller else { 
                print("Ошибка назначения делегата WebViewViewController")
                return }
            delegate = viewController
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            //T0D0: process code
            delegate?.fetchOAuthToken(code: code) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    switch result {
                    case .success(let data):
                        self.storage.token = data.access_token
                        print(self.storage.token)
                    case .failure(let error) :
                        print(error.localizedDescription)
                    }
                }
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}


