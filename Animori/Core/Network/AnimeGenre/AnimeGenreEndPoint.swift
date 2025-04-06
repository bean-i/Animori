//
//  AnimeGenreEndPoint.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

enum AnimeGenreEndPoint: EndPoint {
    
    case genres // getAnimeGenres
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .genres: return "/genres/anime"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .genres: return .get
        }
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        switch self {
        case .genres: return EmptyParameters()
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown)
    }
    
}
