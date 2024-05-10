//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Fedor on 03.05.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init(){}
    
    func logout(){
        cleanCookies()
    }
    
    
    private func cleanCookies(){
        // Очищаем Cookies
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        ProfileImageService.shared.profileImageUrl = nil
        ImageListService.shared.photos = []
        ImageListService.shared.page = 0
    }
}
