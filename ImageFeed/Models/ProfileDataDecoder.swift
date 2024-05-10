//
//  ProfileDataDecoder.swift
//  ImageFeed
//
//  Created by Fedor on 27.03.2024.
//

import Foundation

struct ProfileDataDecoder: Codable {
    var username: String
    var firstName: String
    var lastName: String
    var bio: String?
}
