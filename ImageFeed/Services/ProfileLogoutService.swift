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
        ProfileImageService.shared.profileImageUrl = nil
        ImageListService.shared.photos = []
        OAuth2Service.shared.lastCode = nil
//        ImageListService.shared.delegate?.photos = []
        ImageListService.shared.page = 0
    }
}
