//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Fedor on 16.04.2024.
//

import Foundation

struct PhotoResult:Codable {
    
    let photos: [Photo]
    
    struct Photo: Codable {
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
