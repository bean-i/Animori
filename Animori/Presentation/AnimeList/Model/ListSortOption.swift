//
//  ListSortOption.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation

enum ListSortOption: Int, CaseIterable {
    
    case popularity
    case favorites
    case score

    var displayName: String {
        switch self {
        case .popularity: return "인기순"
        case .favorites: return "좋아요순"
        case .score: return "별점순"
        }
    }

    var apiParameter: String {
        switch self {
        case .popularity: return "popularity"
        case .favorites: return "favorites"
        case .score: return "score"
        }
    }
}
