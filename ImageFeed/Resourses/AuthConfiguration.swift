//
//  Constants.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 18.02.2024.
//

import Foundation

enum Constants {
    static let accessKey = "axcd9X9sH4EtYMesKjEuSNZ40NCMylA7YO4zxWU05mc"
    static let secretKey = "F6DBCmSASFMAGYI6tQ2KuCzQgiXWvu3YKKGPw8BZJNs"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_user+write_photos+write_likes"
    static let defaultBaseApiUrl = "https://api.unsplash.com/"
    static let unsplashAuthirizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultApiUrl = "https://api.unsplash.com/"
    static let tokenRequestURL = "https://unsplash.com/oauth/token"
    static var profileRequestURL = "https://api.unsplash.com/users/"
    static let grantType = "authorization_code"
}

enum URLQueryItemsList: String {
    case clientId = "client_id"
    case redirectURI = "redirect_uri"
    case responseType = "response_type"
    case scope = "scope"
    case clientSecret = "client_secret"
    case code = "code"
    case grantType = "grant_type"
    case page = "page"
    case perPage = "per_page"
    case orderdBy = "order_by"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthirizeURLString)
    }
}
