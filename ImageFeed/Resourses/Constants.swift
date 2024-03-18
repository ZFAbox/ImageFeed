//
//  Constants.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 18.02.2024.
//

import Foundation

enum Constants {
    static let AccessKey = "axcd9X9sH4EtYMesKjEuSNZ40NCMylA7YO4zxWU05mc"
    static let SecretKey = "F6DBCmSASFMAGYI6tQ2KuCzQgiXWvu3YKKGPw8BZJNs"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_user+write_photos+write_likes"
    static let DefaultBaseUrl:URL? = URL(string: "https://api.unsplash.com/")
    static let GrantType = "authorization_code"
}

enum URLQueryItemsList: String {
    case clientId = "client_id"
    case redirectURI = "redirect_uri"
    case responseType = "response_type"
    case scope = "scope"
    case clientSecret = "client_secret"
    case code = "code"
    case grantType = "grant_type"
}
