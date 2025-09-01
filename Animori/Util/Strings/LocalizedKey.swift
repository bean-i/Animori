//
//  LocalizedKey.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

enum LocalizedKey {
    
    enum Sort {
        static let popular = "sort_by_popularity"
        static let liked = "sort_by_likes"
        static let airing = "currently_airing"
        static let upcoming = "upcoming_broadcast"
        static let rating = "rating"
    }
    
    enum RecommendOption {
        static let season = "new_season_anime"
        static let complete = "classic_finished_anime"
        static let movie = "movie_anime"
    }
    
    enum AnimeDetail {
        static let aired = "detail_aired"
        static let character = "detail_character"
        static let ott = "detail_ott"
        static let rating = "detail_rating"
        static let recommend = "detail_recommended"
        static let review = "detail_review"
        static let synopsis = "detail_Synopsis"
    }
    
    enum AnimeSearch {
        static let title = "search"
        static let placeholder = "search_for_anime"
        static let recentSearch = "recent_search"
        static let genre = "genre_shortcuts"
        static let topAnime = "top_anime"
        static let topCharacter = "top_characters"
    }
    
    enum AnimeList {
        static let anime = "animation"
        static let seasonTitle = "anime_list_title_season"
        static let completeTitle = "anime_list_title_complete"
        static let movieTitle = "anime_list_title_movie"
    }
    
    enum MyLibrary {
        static let library = "library"
        static let watching = "library_watching"
        static let toWatch  = "library_toWatch"
        static let watched = "library_watched"
    }
    
    enum Character {
        static let japaneseName = "character_japaneseName"
        static let nickname = "character_nickname"
        static let savedUsers = "character_savedUsers"
        static let bio = "character_bio"
        static let voiceActor = "character_voiceActor"
    }
    
    enum Alert {
        static let title = "alert_networkError_title"
        static let message = "alert_networkError_message"
        static let cancel = "alert_networkError_cancel"
        static let retry = "alert_networkError_retry"
    }
    
    enum Phrase {
        static let loading = "phrase_loading"
        static let translating = "phrase_translating"
        static let more = "phrase_more"
    }
    
    enum Toast {
        static let saved = "toast_saved"
        static let removed = "toast_removed"
    }
    
}
