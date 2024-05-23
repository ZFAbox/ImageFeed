//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.02.2024.
//

import Foundation
import UIKit
import WebKit

class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    var delegate: AuthViewController?
    private let splashController = SplashViewController()
    let storage = OAuth2TokenStorage()
    var estimatedProgreeObservation: NSKeyValueObservation?
    
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
//                 self.updateProgress()
                 self.presenter?.didUpdateProgresValue(self.webView.estimatedProgress)
             })
        presenter?.viewDidLoad()
    }
    
    //MARK: - Class Methods
    
    func setProgressValue(_ newValue: Float) {
        progreesView.progress = newValue
    }
    
    func setProgressIsHidden(_ isHidden: Bool) {
        progreesView.isHidden = isHidden
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
            let url = navigationAction.request.url{
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        guard let delegate else { return }
        delegate.webViewViewControllerDismiss(self)
    }
}

extension WebViewViewController {
    func load(request: URLRequest) {
        webView.load(request)
    }
}


