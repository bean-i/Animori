//
//  AnimeEndPoint.swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

enum AnimeEndPoint: EndPoint {
    
    case topAnime(query: TopAnimeRequest) // getTopAnime
    case seasonNow // getSeasonNow
    case completeAnime(ListSortOption) // getAnimeSearch
    case movieAnime(ListSortOption) // getAnimeSearch
    case animeSearch(String, ListSortOption) // getAnimeSearch
    case animeByGenre(String, ListSortOption) // getAnimeSearch
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .topAnime: return "/top/anime"
        case .seasonNow: return "/seasons/now"
        case .completeAnime, .movieAnime, .animeSearch, .animeByGenre: return "/anime"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topAnime: return .get
        case .seasonNow: return .get
        case .completeAnime: return .get
        case .movieAnime: return .get
        case .animeSearch: return .get
        case .animeByGenre: return .get
        }
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        switch self {
        case .topAnime(let query):
            return query
        case .seasonNow:
            return AnimeRequestDTO.seasonNow.queryParameters
        case .completeAnime(let sortOption):
            return AnimeRequestDTO.completeAnime(sortOption: sortOption).queryParameters
        case .movieAnime(let sortOption):
            return AnimeRequestDTO.movieAnime(sortOption: sortOption).queryParameters
        case .animeSearch(let query, let sortOption):
            return AnimeRequestDTO.search(query, sortOption: sortOption).queryParameters
        case .animeByGenre(let id, let sortOption):
            return AnimeRequestDTO.genre(id, sortOption: sortOption).queryParameters
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown) // 임시
    }
    
}
