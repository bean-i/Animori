//
//  Bundle+.swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

extension Bundle {
    var baseURL: String? {
        return self.object(forInfoDictionaryKey: "BASE_URL") as? String
    }
}
