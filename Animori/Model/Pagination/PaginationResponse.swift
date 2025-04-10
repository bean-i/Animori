//
//  PaginationResponse.swift
//  Animori
//
//  Created by 이빈 on 4/11/25.
//

import Foundation

struct PaginationResponse: Decodable {
    let lastVisiblePage: Int
    let hasNextPage: Bool
    let currentPage: Int
    let items: PaginationItems

    enum CodingKeys: String, CodingKey {
        case lastVisiblePage = "last_visible_page"
        case hasNextPage = "has_next_page"
        case currentPage = "current_page"
        case items
    }
}

struct PaginationItems: Decodable {
    let count: Int
    let total: Int
    let perPage: Int

    enum CodingKeys: String, CodingKey {
        case count, total
        case perPage = "per_page"
    }
}

extension PaginationResponse {
    static var basic: PaginationResponse {
        return PaginationResponse(
            lastVisiblePage: 0,
            hasNextPage: false,
            currentPage: 0,
            items: PaginationItems(count: 0, total: 0, perPage: 0)
        )
    }
}
