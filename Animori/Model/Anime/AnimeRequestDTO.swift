//
//  AnimeRequestDTO .swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation

struct EmptyParameters: Encodable { }

enum AnimeRequestDTO {
    case topAnime(sortOption: SortOption, page: Int)
    case seasonNow(page: Int)
    case completeAnime(sortOption: ListSortOption, page: Int)
    case movieAnime(sortOption: ListSortOption, page: Int)
    case search(String, sortOption: ListSortOption, page: Int)
    case genre(String, sortOption: ListSortOption)
    
    var queryParameters: Encodable {
        switch self {
        case .topAnime(let sortOption, let page):
            return TopAnimeRequest(filter: sortOption.apiParameter, limit: 10, page: page)
        case .seasonNow(let page):
            return SeasonNowRequest(page: page)
        case .completeAnime(let sortOption, let page):
            return AnimeSearchRequest(
                q: nil,
                type: nil,
                status: "complete",
                order_by: sortOption.apiParameter,
                sort: "desc",
                genres: nil,
                page: page
            )
        case .movieAnime(let sortOption, let page):
            return AnimeSearchRequest(
                q: nil,
                type: "movie",
                status: nil,
                order_by: sortOption.apiParameter,
                sort: "desc",
                genres: nil,
                page: page
            )
        case .search(let query, let sortOption, let page):
            return AnimeSearchRequest(
                q: query,
                type: nil,
                status: nil,
                order_by: sortOption.apiParameter,
                sort: "desc",
                genres: nil,
                page: page
            )
        case .genre(let genreID, let sortOption):
            return AnimeSearchRequest(
                q: nil,
                type: nil,
                status: nil,
                order_by: sortOption.apiParameter,
                sort: "desc",
                genres: genreID,
                page: 1
            )
        }
    }
}

// MARK: - TopAnime (인기 Top 애니메이션)
struct TopAnimeRequest: Encodable {
    let filter: String
    let sfw: Bool = true
    let limit: Int
    let page: Int
}

// MARK: - SeasonNow
struct SeasonNowRequest: Encodable {
    let page: Int
}

// MARK: - AnimeSearchRequest
struct AnimeSearchRequest: Encodable {
    let q: String?
    let type: String?
    let status: String?
    let order_by: String?
    let sort: String?
    let sfw: Bool = true
    let genres: String?
    let page: Int
    
    // 기본 인스턴스 예시 (필요 시 함수 형태로 변경 가능)
    static func completeBasic(page: Int) -> AnimeSearchRequest {
        return AnimeSearchRequest(q: nil, type: nil, status: "complete", order_by: "score", sort: "desc", genres: nil, page: page)
    }
    
    static func movieBasic(page: Int) -> AnimeSearchRequest {
        return AnimeSearchRequest(q: nil, type: "movie", status: nil, order_by: "popularity", sort: "desc", genres: nil, page: page)
    }
}

















//struct TopAnimeRequest: Encodable {
//    let filter: String
//    let sfw: Bool = true
//    let limit: Int
//    
//    static var basic: TopAnimeRequest {
//        return TopAnimeRequest(filter: "bypopularity", limit: 10)
//    }
//    
//    static var page: TopAnimeRequest {
//        return TopAnimeRequest(filter: "bypopularity", limit: 25)
//    }
//}
//
//// MARK: - CompleteAnime (완결 명작, 극장판)
//struct AnimeSearchRequest: Encodable {
//    let q: String?
//    let type: String?
//    let status: String?
//    let order_by: String?
//    let sort: String?
//    let sfw: Bool = true
//    let genres: String?
//    
//    static var completeBasic: AnimeSearchRequest {
//        return AnimeSearchRequest(q: nil, type: nil, status: "complete", order_by: "score", sort: "desc", genres: nil)
//    }
//    
//    static var movieBasic: AnimeSearchRequest {
//        return AnimeSearchRequest(q: nil, type: "movie", status: nil, order_by: "popularity", sort: "desc", genres: nil)
//    }
//    
//}
