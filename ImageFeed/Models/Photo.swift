//
//  Photo.swift
//  ImageFeed
//
//  Created by Fedor on 16.04.2024.
//

import Foundation

struct Photo {
    var id: String
    var size: CGSize
    var createdAt: Date?
    var welcomeDescription: String?
    var thumbImageURL: String
    var largeImageURL: String
    var isLiked: Bool
}
