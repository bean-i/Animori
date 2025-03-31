//
//  AnimeEndPoint.swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

enum AnimeEndPoint: EndPoint {
    
    case topAnime // getTopAnime
    case seasonNow // getSeasonNow
    case completeAnime // getAnimeSearch
    case movieAnime // getAnimeSearch
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .topAnime: return "/top/anime"
        case .seasonNow: return "/seasons/now"
        case .completeAnime, .movieAnime: return "/anime"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topAnime: return .get
        case .seasonNow: return .get
        case .completeAnime: return .get
        case .movieAnime: return .get
        }
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        switch self {
        case .topAnime:
            return AnimeRequestDTO.topAnime.queryParameters
        case .seasonNow:
            return AnimeRequestDTO.seasonNow.queryParameters
        case .completeAnime:
            return AnimeRequestDTO.completeAnime.queryParameters
        case .movieAnime:
            return AnimeRequestDTO.movieAnime.queryParameters
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown) // 임시
    }
    
}
