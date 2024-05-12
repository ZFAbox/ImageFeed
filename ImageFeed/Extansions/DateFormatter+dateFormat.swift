//
//  DateFormatter+dateFormat.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 11.05.2024.
//

import Foundation


extension DateFormatter {
    
    static func dateFormat(date: Date) -> String {
        var curentDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMMyyyy")
        for charackter in dateFormatter.string(from: date) {
            if charackter != "г" {
                if charackter != "." {
                    curentDate.append(charackter)
                }
            }
        }
        return curentDate
    }
}


