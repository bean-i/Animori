//
//  LocalizedStrings.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

enum LocalizedStrings {
    
    enum Sort {
        static let popular = NSLocalizedString(LocalizedKey.Sort.popular, comment: "")
        static let liked = NSLocalizedString(LocalizedKey.Sort.liked, comment: "")
        static let airing = NSLocalizedString(LocalizedKey.Sort.airing, comment: "")
        static let upcoming = NSLocalizedString(LocalizedKey.Sort.upcoming, comment: "")
        static let rating = NSLocalizedString(LocalizedKey.Sort.rating, comment: "")
    }
    
    enum RecommendOption {
        static let season = NSLocalizedString(LocalizedKey.RecommendOption.season, comment: "")
        static let complete = NSLocalizedString(LocalizedKey.RecommendOption.complete, comment: "")
        static let movie = NSLocalizedString(LocalizedKey.RecommendOption.movie, comment: "")
    }
    
    enum AnimeDetail {
        static let aired = NSLocalizedString(LocalizedKey.AnimeDetail.aired, comment: "")
        static let character = NSLocalizedString(LocalizedKey.AnimeDetail.character, comment: "")
        static let ott = NSLocalizedString(LocalizedKey.AnimeDetail.ott, comment: "")
        static let rating = NSLocalizedString(LocalizedKey.AnimeDetail.rating, comment: "")
        static let recommend = NSLocalizedString(LocalizedKey.AnimeDetail.recommend, comment: "")
        static let review = NSLocalizedString(LocalizedKey.AnimeDetail.review, comment: "")
        static let synopsis = NSLocalizedString(LocalizedKey.AnimeDetail.synopsis, comment: "")
    }
    
    enum AnimeSearch {
        static let title = NSLocalizedString(LocalizedKey.AnimeSearch.title, comment: "")
        static let placeholder = NSLocalizedString(LocalizedKey.AnimeSearch.placeholder, comment: "")
        static let recentSearch = NSLocalizedString(LocalizedKey.AnimeSearch.recentSearch, comment: "")
        static let genre = NSLocalizedString(LocalizedKey.AnimeSearch.genre, comment: "")
        static let topAnime = NSLocalizedString(LocalizedKey.AnimeSearch.topAnime, comment: "")
        static let topCharacter = NSLocalizedString(LocalizedKey.AnimeSearch.topCharacter, comment: "")
    }
    
    enum AnimeList {
        static let anime = NSLocalizedString(LocalizedKey.AnimeList.anime, comment: "")
        static let seasonTitle = NSLocalizedString(LocalizedKey.AnimeList.seasonTitle, comment: "")
        static let completeTitle = NSLocalizedString(LocalizedKey.AnimeList.completeTitle, comment: "")
        static let movieTitle = NSLocalizedString(LocalizedKey.AnimeList.movieTitle, comment: "")
    }
    
}
