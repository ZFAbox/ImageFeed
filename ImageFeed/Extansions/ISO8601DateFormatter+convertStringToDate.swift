//
//  ISO8601DateFormatter+.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 11.05.2024.
//

import Foundation


extension ISO8601DateFormatter {
    
    static func convertStringToDate(stringDate: String?) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        guard let stringDate else {
            print("Пустая дата")
            return nil}
        let date = dateFormatter.date(from: stringDate)
        return date
    }
    
}
