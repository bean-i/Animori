//
//  AnimeEndPoint.swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

enum AnimeEndPoint: EndPoint {
    
    case topAnime(sortOption: SortOption, page: Int) // getTopAnime
    case seasonNow(page: Int) // getSeasonNow
    case completeAnime(sortOption: ListSortOption, page: Int) // getAnimeSearch
    case movieAnime(sortOption: ListSortOption, page: Int) // getAnimeSearch
    case animeSearch(query: String, sortOption: ListSortOption, page: Int) // getAnimeSearch
    case animeByGenre(genre: AnimeGenreProtocol, sortOption: ListSortOption) // getAnimeSearch
    
    var baseURL: String? { return Bundle.main.baseURL }
    
    var path: String {
        switch self {
        case .topAnime:
            return "/top/anime"
        case .seasonNow:
            return "/seasons/now"
        case .completeAnime, .movieAnime, .animeSearch, .animeByGenre:
            return "/anime"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        switch self {
        case .topAnime(let sortOption, let page):
            return AnimeRequestDTO.topAnime(sortOption: sortOption, page: page).queryParameters
        case .seasonNow(let page):
            return AnimeRequestDTO.seasonNow(page: page).queryParameters
        case .completeAnime(let sortOption, let page):
            return AnimeRequestDTO.completeAnime(sortOption: sortOption, page: page).queryParameters
        case .movieAnime(let sortOption, let page):
            return AnimeRequestDTO.movieAnime(sortOption: sortOption, page: page).queryParameters
        case .animeSearch(let query, let sortOption, let page):
            return AnimeRequestDTO.search(query, sortOption: sortOption, page: page).queryParameters
        case .animeByGenre(let genre, let sortOption):
            return AnimeRequestDTO.genre(String(genre.id), sortOption: sortOption).queryParameters
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown)
    }
}
