//
//  OAuthTokenResponseDecoder.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 10.03.2024.
//

import Foundation

class SnakeCaseJsonDecoder: JSONDecoder {
    override init() {
        super .init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}

struct OAuthTokenResponseDecoder: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
}
