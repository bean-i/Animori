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
    case completeAnime // getAnimeSearch
    case movieAnime // getAnimeSearch
    case animeSearch(String) // getAnimeSearch
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .topAnime: return "/top/anime"
        case .seasonNow: return "/seasons/now"
        case .completeAnime, .movieAnime, .animeSearch: return "/anime"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topAnime: return .get
        case .seasonNow: return .get
        case .completeAnime: return .get
        case .movieAnime: return .get
        case .animeSearch: return .get
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
        case .completeAnime:
            return AnimeRequestDTO.completeAnime.queryParameters
        case .movieAnime:
            return AnimeRequestDTO.movieAnime.queryParameters
        case .animeSearch(let query):
            return AnimeRequestDTO.search(query).queryParameters
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown) // 임시
    }
    
}
