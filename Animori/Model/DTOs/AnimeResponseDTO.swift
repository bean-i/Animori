//
//  AnimeDTO.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

// MARK: - Response
struct AnimeResponseDTO: Decodable {
    let data: [AnimeDTO]
}

struct AnimeDTO: Decodable {
    let id: Int
    let images: AnimeImage
    let titles: [AnimeTitle]
    let score: Double?
    let genres: [AnimeGenre]
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case images, titles, score, genres
    }
}

struct AnimeImage: Decodable {
    let jpg: AnimeJPG
}

struct AnimeJPG: Decodable {
    let imageURL: String?
    let largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case largeImageURL = "large_image_url"
    }
}

struct AnimeTitle: Decodable {
    let type: String
    let title: String
}

struct AnimeGenre: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case name
    }
}

// MARK: - AnimeDTO Extension: empty data
extension AnimeDTO {
    static var empty: AnimeDTO {
        return AnimeDTO(
            id: 0,
            images: AnimeImage(jpg: AnimeJPG(imageURL: nil, largeImageURL: nil)),
            titles: [],
            score: 0.0,
            genres: []
        )
    }
}

// MARK: - AnimeDTO Extension: toEntity
extension AnimeDTO {
    func toEntity() -> Anime {
        let preferredTitle = self.titles.first(where: { $0.type == "Japanese" })?.title ?? self.titles.first?.title ?? ""
        let image = self.images.jpg.largeImageURL ?? ""
        let genre = self.genres.map { "#\($0.name)" }
        let rate = self.score.map { String($0) } ?? "N/A"
        
        return Anime(
            id: self.id,
            title: preferredTitle,
            image: image,
            genre: genre,
            rate: rate
        )
    }
}

// MARK: - 빈 데이터
extension AnimeResponseDTO {
    static var empty: AnimeResponseDTO {
        return AnimeResponseDTO(data: [])
    }
}
