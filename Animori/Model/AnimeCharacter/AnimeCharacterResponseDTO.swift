//
//  AnimeCharacterResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

struct AnimeCharacterResponseDTO: Decodable {
    let data: [AnimeCharacterDTO]
}

struct AnimeCharacterDTO: Decodable {
    let character: AnimeCharacter
}

struct AnimeCharacter: Decodable {
    let characterId: Int
    let images: AnimeImage
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case characterId = "mal_id"
        case images, name
    }
}

// MARK: - AnimeCharacterResponseDTO Extension: empty data
extension AnimeCharacterResponseDTO {
    static var empty: AnimeCharacterResponseDTO {
        return AnimeCharacterResponseDTO(data: [])
    }
}

// MARK: - AnimeCharacterDTO Extension: empty data
extension AnimeCharacterDTO {
    static var empty: AnimeCharacterDTO {
        return AnimeCharacterDTO(
            character: AnimeCharacter(
                characterId: 0,
                images: AnimeImage(jpg: AnimeJPG(imageURL: "", largeImageURL: "")),
                name: ""
            )
        )
    }
}

// MARK: - AnimeCharacterDTO Extension: toEntity
extension AnimeCharacterDTO {
    func toEntity() -> any AnimeCharacterProtocol {
        return AnimeCharacterEntity(
            id: self.character.characterId,
            name: self.character.name,
            image: self.character.images.jpg.imageURL ?? ""
        )
    }
}
