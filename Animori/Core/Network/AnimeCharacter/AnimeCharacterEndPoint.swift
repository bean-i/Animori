//
//  AnimeCharacterEndPoint.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

enum AnimeCharacterEndPoint: EndPoint {
    
    case topCharacter // getTopCharacters
    case characterPictures(Int) // getCharacterPictures
    case characterInfo(Int) // getCharacterById
    case characterVoiceActors(Int)// getCharacterVoiceActors
    
    var baseURL: String? { return Bundle.main.baseURL }
    var path: String {
        switch self {
        case .topCharacter: return "/top/characters"
        case .characterPictures(let id): return "/characters/\(id)/pictures"
        case .characterInfo(let id): return "/characters/\(id)"
        case .characterVoiceActors(let id): return "/characters/\(id)/voices"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .topCharacter: return .get
        case .characterPictures: return .get
        case .characterInfo: return .get
        case .characterVoiceActors: return .get
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
