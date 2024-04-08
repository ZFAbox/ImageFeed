//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 16.03.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private lazy var keychain = KeychainWrapper.standard
    enum Keys: String {
        case token
    }
    var token: String? {
        get {
            let token: String? = keychain.string(forKey: Keys.token.rawValue)
            return token
        }
        set {
            guard let token = newValue else { return }
            let isSuccess = keychain.set(token, forKey: Keys.token.rawValue)
            guard isSuccess else { return }
        }
    }
    
}
