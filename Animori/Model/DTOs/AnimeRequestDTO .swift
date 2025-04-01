//
//  AnimeRequestDTO .swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

struct EmptyParameters: Encodable { }

// MARK: - AnimeRequestDTO
enum AnimeRequestDTO {
    case topAnime
    case seasonNow
    case completeAnime
    case movieAnime
    
    var queryParameters: Encodable {
        switch self {
        case .topAnime:
            return TopAnimeRequest.basic
        case .seasonNow:
            return EmptyParameters()
        case .completeAnime:
            return AnimeSearchRequest.completeBasic
        case .movieAnime:
            return AnimeSearchRequest.movieBasic
        }
    }
    
}

// MARK: - TopAnime (인기Top 애니메이션)
struct TopAnimeRequest: Encodable {
    let filter: String
    let sfw: Bool = true
    let limit: Int
    
    static var basic: TopAnimeRequest {
        return TopAnimeRequest(filter: "bypopularity", limit: 10)
    }
}

// MARK: - CompleteAnime (완결 명작, 극장판)
struct AnimeSearchRequest: Encodable {
    let type: String?
    let status: String?
    let order_by: String?
    let sort: String?
    let sfw: Bool = true
    
    static var completeBasic: AnimeSearchRequest {
        return AnimeSearchRequest(type: nil, status: "complete", order_by: "score", sort: "desc")
    }
    
    static var movieBasic: AnimeSearchRequest {
        return AnimeSearchRequest(type: "movie", status: nil, order_by: "popularity", sort: "desc")
    }
    
}
