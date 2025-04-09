//
//  AnimeCharacterInfoResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import Foundation
// MARK: - getCharacterById
struct AnimeCharacterInfoResponseDTO: Decodable {
    let data: AnimeCharacterInfoDTO
}

struct AnimeCharacterInfoDTO: Decodable {
    let name: String
    let kanjiName: String?
    let nicknames: [String]
    let favorites: Int
    let about: String?
    
    enum CodingKeys: String, CodingKey {
        case name, nicknames, favorites, about
        case kanjiName = "name_kanji"
    }
}


// MARK: - AnimeCharacterInfoResponseDTO Extension: empty data
extension AnimeCharacterInfoResponseDTO {
    static var empty: AnimeCharacterInfoResponseDTO {
        return AnimeCharacterInfoResponseDTO(
            data: AnimeCharacterInfoDTO.empty
        )
    }
}

// MARK: - AnimeCharacterInfoDTO Extension: empty data
extension AnimeCharacterInfoDTO {
    static var empty: AnimeCharacterInfoDTO {
        return AnimeCharacterInfoDTO(name: "", kanjiName: "", nicknames: [], favorites: 0, about: "")
    }
}

// MARK: - AnimeCharacterInfoDTO Extension: toEntity
extension AnimeCharacterInfoDTO {
    func toEntity() -> AnimeCharacterInfoProtocol {
        let favorites = NumberFormatter.formatted(self.favorites)
        return AnimeCharacterInfoEntity(
            name: self.name,
            kanjiName: self.kanjiName ?? "X",
            nickname: self.nicknames.first ?? "X",
            favorites: favorites,
            about: self.about ?? "X"
        )
    }
}
