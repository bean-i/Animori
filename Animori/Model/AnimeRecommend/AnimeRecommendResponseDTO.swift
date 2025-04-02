//
//  AnimeRecommendResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

struct AnimeRecommendResponseDTO: Decodable {
    let data: [AnimeRecommendDTO]
}

struct AnimeRecommendDTO: Decodable {
    let entry: AnimeRecommendInfoDTO
}

struct AnimeRecommendInfoDTO: Decodable {
    let id: Int
    let images: AnimeImage
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case images, title
    }
}

// MARK: - AnimeRecommendResponseDTO Extension: empty data
extension AnimeRecommendResponseDTO {
    static var empty: AnimeRecommendResponseDTO {
        return AnimeRecommendResponseDTO(data: [])
    }
}

// MARK: - AnimeRecommendDTO Extension: empty data
extension AnimeRecommendDTO {
    static var empty: AnimeRecommendDTO {
        return AnimeRecommendDTO(
            entry: AnimeRecommendInfoDTO(
                id: 0,
                images: AnimeImage(jpg: AnimeJPG(imageURL: "", largeImageURL: "")),
                title: ""
            )
        )
    }
}

// MARK: - AnimeRecommendDTO Extension: toEntity
extension AnimeRecommendDTO {
    func toEntity() -> any AnimeRecommendProtocol {
        return AnimeRecommendEntity(title: self.entry.title,
                                    image: self.entry.images.jpg.imageURL ?? "")
    }
}
