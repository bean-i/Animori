//
//  AnimeDetailEndPoint.swift
//  Animori
//
//  Created by 이빈 on 4/3/25.
//

import Foundation

enum AnimeDetailEndPoint: EndPoint {

    case fullAnimeInfo(Int)
    case animeReviews(Int)
    case animeRecommendations(Int)
    case animeCharacters(Int)
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .fullAnimeInfo(let id):
            return "/anime/\(id)/full"
        case .animeReviews(let id):
            return "/anime/\(id)/reviews"
        case .animeRecommendations(let id):
            return "/anime/\(id)/recommendations"
        case .animeCharacters(let id):
            return "/anime/\(id)/characters"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fullAnimeInfo: return .get
        case .animeReviews: return .get
        case .animeRecommendations: return .get
        case .animeCharacters: return .get
        }
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        return EmptyParameters()
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown)
    }
    
}
