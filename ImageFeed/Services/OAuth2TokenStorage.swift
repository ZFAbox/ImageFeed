//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 16.03.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private lazy var userDefaults = UserDefaults.standard
    private let authViewController = AuthViewController()
    enum Keys: String {
        case token
    }
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
}
