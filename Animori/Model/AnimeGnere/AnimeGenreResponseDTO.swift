//
//  AnimeGenreResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

struct AnimeGenreResponseDTO: Decodable {
    let data: [AnimeGenreDTO]
}

struct AnimeGenreDTO: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case name
    }
}

// MARK: - AnimeGenreResponseDTO Extension: empty data
extension AnimeGenreResponseDTO {
    static var empty: AnimeGenreResponseDTO {
        return AnimeGenreResponseDTO(data: [])
    }
}

// MARK: - AnimeGenreDTO Extension: empty data
extension AnimeGenreDTO {
    static var empty: AnimeGenreDTO {
        return AnimeGenreDTO(id: 0, name: "")
    }
}

// MARK: - AnimeCharacterDTO Extension: toEntity
extension AnimeGenreDTO {
    func toEntity() -> any AnimeGenreProtocol {
        return AnimeGenreEntity(id: self.id, name: "# \(self.name)")
    }
}
