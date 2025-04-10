//
//  AnimeCharacterVoiceActorsResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import Foundation

// MARK: - getCharacterVoiceActors
struct AnimeCharacterVoiceActorsResponseDTO: Decodable {
    let data: [AnimeCharacterVoiceActorsDTO]
}

struct AnimeCharacterVoiceActorsDTO: Decodable {
    let language: String
    let person: AnimeCharacterVoiceActorsPreson
}

struct AnimeCharacterVoiceActorsPreson: Decodable {
    let images: AnimeCharacterPicturesDTO
    let name: String
}

// MARK: - AnimeCharacterVoiceActorsResponseDTO Extension: empty data
extension AnimeCharacterVoiceActorsResponseDTO {
    static var empty: AnimeCharacterVoiceActorsResponseDTO {
        return AnimeCharacterVoiceActorsResponseDTO(data: [])
    }
}

// MARK: - AnimeCharacterVoiceActorsDTO Extension: empty data
extension AnimeCharacterVoiceActorsDTO {
    static var empty: AnimeCharacterVoiceActorsDTO {
        return AnimeCharacterVoiceActorsDTO(
            language: "",
            person: AnimeCharacterVoiceActorsPreson(
                images: AnimeCharacterPicturesDTO(jpg: AnimeCharacterPicturesImage(image: "")),
                name: ""
            )
        )
    }
}

// MARK: - AnimeCharacterVoiceActorsDTO Extension: toEntity
extension AnimeCharacterVoiceActorsDTO {
    func toEntity() -> any AnimeCharacterVoiceActorsProtocol {
        return AnimeCharacterVoiceActorsEntity(
            language: self.language,
            name: self.person.name,
            image: self.person.images.jpg.image ?? ""
        )
    }
}
