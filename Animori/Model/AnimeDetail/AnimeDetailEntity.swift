//
//  AnimeDetailEntity.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

struct AnimeDetailEntity: AnimeDetailProtocol {
    let id: Int
    let title: String
    let image: String
    let genre: [String]
    let rate: String
    let age: String
    let airedPeriod: String
    let plot: String
    let OTT: [AnimeDetailOTT]
}

extension AnimeDetailEntity {
    static var empty: AnimeDetailEntity {
        return AnimeDetailEntity(
            id: 0,
            title: "",
            image: "",
            genre: [],
            rate: "",
            age: "",
            airedPeriod: "",
            plot: "",
            OTT: []
        )
    }
}
