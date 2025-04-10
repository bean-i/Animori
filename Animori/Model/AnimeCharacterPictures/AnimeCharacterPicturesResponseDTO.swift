//
//  AnimeCharacterPicturesResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import Foundation

// MARK: - getCharacterPictures
struct AnimeCharacterPicturesResponseDTO: Decodable {
    let data: [AnimeCharacterPicturesDTO]
}

struct AnimeCharacterPicturesDTO: Decodable {
    let jpg: AnimeCharacterPicturesImage
}

struct AnimeCharacterPicturesImage: Decodable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "image_url"
    }
}

// MARK: - AnimeCharacterPicturesResponseDTO Extension: empty data
extension AnimeCharacterPicturesResponseDTO {
    static var empty: AnimeCharacterPicturesResponseDTO {
        return AnimeCharacterPicturesResponseDTO(data: [])
    }
}

// MARK: - AnimeCharacterPicturesDTO Extension: empty data
extension AnimeCharacterPicturesDTO {
    static var empty: AnimeCharacterPicturesDTO {
        return AnimeCharacterPicturesDTO(jpg: AnimeCharacterPicturesImage(image: ""))
    }
}

// MARK: - AnimeCharacterDTO Extension: toEntity
extension AnimeCharacterPicturesDTO {
    func toEntity() -> any AnimeCharacterPicturesProtocol {
        return AnimeCharacterPicturesEntity(
            image: self.jpg.image ?? ""
        )
    }
}
