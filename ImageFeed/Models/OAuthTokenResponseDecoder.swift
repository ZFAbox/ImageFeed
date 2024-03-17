//
//  OAuthTokenResponseDecoder.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 10.03.2024.
//

import Foundation

struct OAuthTokenResponseDecoder: Codable {
    var access_token: String
    var token_type: String
    var scope: String
    var created_at: Int
    
    private enum CodingKeys: String, CodingKey {
        case access_token = "access_token"
        case token_type = "token_type"
        case scope = "scope"
        case created_at = "created_at"
    }
}
