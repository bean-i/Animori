//
//  TopCharacterResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation

struct TopCharacterResponseDTO: Decodable {
    let data: [TopCharacterDTO]
}

//struct TopCharacterDTO: Decodable {
//    let character: TopCharacter
//}

struct TopCharacterDTO: Decodable {
    let characterId: Int
    let images: TopCharacterImage
    let name: String
    let favorites: Int
    
    enum CodingKeys: String, CodingKey {
        case characterId = "mal_id"
        case images, name, favorites
    }
}

struct TopCharacterImage: Decodable {
    let jpg: TopCharacterJPG
}

struct TopCharacterJPG: Decodable {
    let imageURL: String?
    let smallImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
    }
}

// MARK: - TopCharacterResponseDTO Extension: empty data
extension TopCharacterResponseDTO {
    static var empty: TopCharacterResponseDTO {
        return TopCharacterResponseDTO(data: [])
    }
}

// MARK: - TopCharacterDTO Extension: empty data
extension TopCharacterDTO {
    static var empty: TopCharacterDTO {
        return TopCharacterDTO(
            characterId: 0,
            images: TopCharacterImage(jpg: TopCharacterJPG(imageURL: "", smallImageURL: "")),
            name: "",
            favorites: 0
        )
    }
}

// MARK: - TopCharacterDTO Extension: toEntity
extension TopCharacterDTO {
    func toEntity() -> any TopCharacterProtocol {
        var image = self.images.jpg.imageURL ?? ""
        if image.isEmpty {
            image = self.images.jpg.smallImageURL ?? ""
        }
        
        let favorites = "Like \(NumberFormatter.formatted(self.favorites))"

        return TopCharacterEntity(
            id: self.characterId,
            image: image,
            name: self.name,
            favorites: favorites
        )
    }
}
