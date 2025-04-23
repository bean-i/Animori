//
//  AnimeRandomModel.swift
//  Animori
//
//  Created by 이빈 on 4/22/25.
//

import Foundation

struct RandomAnimeResponseDTO: Decodable {
    let data: RandomAnimeDTO
}

struct RandomAnimeDTO: Decodable {
    let id: Int
    let images: RandomAnimeImage
    let titles: [RandomAnimeTitle]
    let score: Double?
    let scoredBy: Int?
    let favorites: Int?
    let synopsis: String
    let genres: [RandomAnimeGenre]
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case scoredBy = "scored_by"
        case images, titles, score, favorites, genres, synopsis
    }
}

struct RandomAnimeImage: Decodable {
    let jpg: RandomAnimeJPG
}

struct RandomAnimeJPG: Decodable {
    let imageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case largeImageURL = "large_image_url"
    }
}

struct RandomAnimeTitle: Decodable {
    let type: String
    let title: String
}

struct RandomAnimeGenre: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case name
    }
}
