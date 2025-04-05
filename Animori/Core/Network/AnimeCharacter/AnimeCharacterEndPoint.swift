//
//  AnimeCharacterEndPoint.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

enum AnimeCharacterEndPoint: EndPoint {
    
    case topCharacter // getTopCharacters
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .topCharacter: return "/top/characters"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topCharacter: return .get
        }
    }
    
    var decoder: JSONDecoder { return JSONDecoder() }
    
    var encoder: JSONEncoder { return JSONEncoder() }
    
    var parameters: Encodable {
        switch self {
        case .topCharacter: return EmptyParameters()
        }
    }
    
    func error(_ statusCode: Int?, data: Data) -> any Error {
        return URLError(.unknown) // 임시
    }
    
}
