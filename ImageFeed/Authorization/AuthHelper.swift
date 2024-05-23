//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Fedor on 23.05.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: configuration.accessKey),
            URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: configuration.redirectURI),
            URLQueryItem(name: URLQueryItemsList.responseType.rawValue, value: "code"),
            URLQueryItem(name: URLQueryItemsList.scope.rawValue, value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if
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
    
}
