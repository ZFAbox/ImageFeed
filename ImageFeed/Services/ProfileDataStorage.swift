//
//  ProfileDataStorage.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.03.2024.
//

import Foundation

final class ProfileDataStorage {
    private lazy var userDefaults = UserDefaults.standard
    enum Keys: String {
        case userProfile
    }
    var profile: ProfileModel {
        get {
            guard let data = userDefaults.data(forKey: Keys.userProfile.rawValue),
                  let model = try? JSONDecoder().decode(ProfileModel.self, from: data) else {
                return .init(username: "", name: "", loginName: "", bio: nil)
            }
            return model
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return}
            userDefaults.set(data, forKey: Keys.userProfile.rawValue)
        }
    }
    
}

