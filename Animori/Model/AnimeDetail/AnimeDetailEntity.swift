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
    let OTT: [String]
}
