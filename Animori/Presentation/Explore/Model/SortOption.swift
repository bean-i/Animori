//
//  SortOption.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

enum SortOption: Int, CaseIterable {
    case popular
    case liked
    case airing
    case upcoming

    var displayName: String {
        switch self {
        case .popular: return LocalizedStrings.Sort.popular
        case .liked: return LocalizedStrings.Sort.liked
        case .airing: return LocalizedStrings.Sort.airing
        case .upcoming: return LocalizedStrings.Sort.upcoming
        }
    }

    var apiParameter: String {
        switch self {
        case .popular: return "bypopularity"
        case .liked: return "favorite"
        case .airing: return "airing"
        case .upcoming: return "upcoming"
        }
    }
}
