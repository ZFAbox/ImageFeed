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
    
//    init(view: WebViewViewControllerProtocol?) {
//        self.view = view
//    }
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthirizeURLString) else {
//            print("Ошибка формирования труктуры URLComponentns")
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: Constants.accessKey),
//            URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: Constants.redirectURI),
//            URLQueryItem(name: URLQueryItemsList.responseType.rawValue, value: "code"),
//            URLQueryItem(name: URLQueryItemsList.scope.rawValue, value: Constants.accessScope)
//        ]
//        guard let url = urlComponents.url else {
//            print ("Ошибка формирования URL")
//            return
//        }
//        let request = URLRequest(url: url)
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
//        if
//            let urlComponents = URLComponents(string: url.absoluteString),
//            urlComponents.path == "/oauth/authorize/native",
//            let items = urlComponents.queryItems,
//            let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        authHelper.code(from: url)
    }
}
