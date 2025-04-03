//
//  DateFormatter+.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

extension DateFormatter {
    
    static let isoToYMD = { (str: String?) -> String in
        guard let str = str else { return "?" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        
        guard let date = formatter.date(from: str) else { return "?" }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd"
        displayFormatter.locale = Locale.current
        displayFormatter.timeZone = TimeZone.current
        return displayFormatter.string(from: date)
    }
}
