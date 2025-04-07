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
    
}
