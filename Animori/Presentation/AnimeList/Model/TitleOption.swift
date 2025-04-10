//
//  TitleOption.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation

enum TitleOption {
    case topAnime
    case seasonNow
    case complete
    case movie
    case search(String)
    
    var displayName: String {
        switch self {
        case .topAnime: return LocalizedStrings.AnimeSearch.topAnime
        case .seasonNow: return LocalizedStrings.AnimeList.seasonTitle
        case .complete: return LocalizedStrings.AnimeList.completeTitle
        case .movie: return LocalizedStrings.AnimeList.movieTitle
        case .search(let searchKeyword): return searchKeyword
        }
    }
}
