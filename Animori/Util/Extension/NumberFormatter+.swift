//
//  NumberFormatter+.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

extension NumberFormatter {
    
    static let formatted = { (value: Int) -> String in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let result = formatter.string(from: value as NSNumber) else {
            return "0"
        }
        return result
    }
    
}
