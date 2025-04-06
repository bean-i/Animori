//
//  RecommendOption.swift
//  Animori
//
//  Created by 이빈 on 3/30/25.
//

import Foundation

enum RecommendOption: String, CaseIterable {
    case season
    case complete
    case short
    
    var displayName: String {
        switch self {
        case .season:
            return LocalizedStrings.RecommendOption.season
        case .complete:
            return LocalizedStrings.RecommendOption.complete
        case .short:
            return LocalizedStrings.RecommendOption.movie
        }
    }
}
