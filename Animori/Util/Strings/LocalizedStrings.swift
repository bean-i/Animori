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
    
    enum MyLibrary {
        static let library = NSLocalizedString(LocalizedKey.MyLibrary.library, comment: "")
        static let watching = NSLocalizedString(LocalizedKey.MyLibrary.watching, comment: "")
        static let toWatch = NSLocalizedString(LocalizedKey.MyLibrary.toWatch, comment: "")
        static let watched = NSLocalizedString(LocalizedKey.MyLibrary.watched, comment: "")
    }
    
    enum Character {
        static let japaneseName = NSLocalizedString(LocalizedKey.Character.japaneseName, comment: "")
        static let nickname = NSLocalizedString(LocalizedKey.Character.nickname, comment: "")
        static let savedUsers = NSLocalizedString(LocalizedKey.Character.savedUsers, comment: "")
        static let bio = NSLocalizedString(LocalizedKey.Character.bio, comment: "")
        static let voiceActor = NSLocalizedString(LocalizedKey.Character.voiceActor, comment: "")
    }
    
    enum Alert {
        static let title = NSLocalizedString(LocalizedKey.Alert.title, comment: "")
        static let message = NSLocalizedString(LocalizedKey.Alert.message, comment: "")
        static let cancel = NSLocalizedString(LocalizedKey.Alert.cancel, comment: "")
        static let retry = NSLocalizedString(LocalizedKey.Alert.retry, comment: "")
    }
    
    enum Phrase {
        static let loading = NSLocalizedString(LocalizedKey.Phrase.loading, comment: "")
        static let translating = NSLocalizedString(LocalizedKey.Phrase.translating, comment: "")
        static let more = NSLocalizedString(LocalizedKey.Phrase.more, comment: "")
    }
    
    enum Toast {
        case save(String)
        case remove
        
        var message: String {
            switch self {
            case .save(let to):
                return String(format: NSLocalizedString(LocalizedKey.Toast.saved, comment: ""), to)
            case .remove:
                return NSLocalizedString(LocalizedKey.Toast.removed, comment: "")
            }
        }
    }
}
