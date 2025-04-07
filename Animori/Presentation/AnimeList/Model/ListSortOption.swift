//
//  ListSortOption.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation

enum ListSortOption: Int, CaseIterable {
    
    case scoredBy
    case favorites
    case score

    var displayName: String {
        switch self {
        case .scoredBy: return LocalizedStrings.Sort.popular
        case .favorites: return LocalizedStrings.Sort.liked
        case .score: return LocalizedStrings.Sort.rating
        }
    }

    var apiParameter: String {
        switch self {
        case .scoredBy: return "scored_by"
        case .favorites: return "favorites"
        case .score: return "score"
        }
    }
}
