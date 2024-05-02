//
//  SinglePhotoUpdate.swift
//  ImageFeed
//
//  Created by Fedor on 02.05.2024.
//

import Foundation

struct SinglePhotoUpdate:Codable {
    
    let photo: SinglePhoto
    
    struct SinglePhoto: Codable {
        let id: String
        let createdAt: String?
        let width: Int
        let height: Int
        let likedByUser: Bool
        let description: String?
        let urls: UrlsResult
        
        struct UrlsResult: Codable {
            let raw: String
            let full: String
            let regular: String
            let small: String
            let thumb: String
        }
    }
}
