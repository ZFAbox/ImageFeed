//
//  ProfileDataDecoder.swift
//  ImageFeed
//
//  Created by Fedor on 27.03.2024.
//

import Foundation

struct ProfileDataDecoder: Decodable {
    var id: String
    var updatedAt: String
    var username: String
    var firstName: String
    var lastName: String
    var twitterUsername: String
    var portfolioUrl: String?
    var bio: String
    var location: String
    var totalLikes: Int
    var totalPhotos: Int
    var totalCollections: Int
    var followedByUser: Bool
}
