//
//  UserResultImageDecoder.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 01.04.2024.
//

import Foundation

struct UserResultImageDecoder: Codable {
    let profileImage: ImageSizes
    
    struct ImageSizes: Codable {
        let small: String
        let medium: String
        let large: String
    }
}
