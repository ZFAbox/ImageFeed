//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Fedor on 22.05.2024.
//

import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgresValue(_ newValue: Double)
    func code(from url: URL) -> String?
}


final class WebViewPresenter: WebViewPresenterProtocol {
    
    var authHelper: AuthHelperProtocol
    enum WebViewConstants {
        static let unsplashAuthirizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    weak var view: WebViewViewControllerProtocol?
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        didUpdateProgresValue(0)
        view?.load(request: request)
    }
    
}

extension WebViewPresenter {
    func didUpdateProgresValue(_ newValue: Double) {
        let newProgreeValue = Float(newValue)
        
        view?.setProgressValue(newProgreeValue)
        let shouldHideProgress = shouldHideProgress(for: newProgreeValue)
        view?.setProgressIsHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

extension WebViewPresenter {
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
