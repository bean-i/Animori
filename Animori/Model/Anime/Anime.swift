//
//  Anime.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

struct Anime: AnimeProtocol {
    let id: Int
    let title: String
    let image: String
    let genre: [String]
    let rate: String
    let popularity: Int
    let favorites: Int
}
