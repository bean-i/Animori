//
//  AnimeCharacterMockData.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

let mockAnimeCharacterResponse = AnimeCharacterResponseDTO(data: [
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 101,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/101.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/101l.jpg"
                )
            ),
            name: "Sakura Haruno"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 102,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/102.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/102l.jpg"
                )
            ),
            name: "Naruto Uzumaki"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 103,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/103.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/103l.jpg"
                )
            ),
            name: "Sasuke Uchiha"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 104,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/104.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/104l.jpg"
                )
            ),
            name: "Kakashi Hatake"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 105,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/105.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/105l.jpg"
                )
            ),
            name: "Hinata Hyuga"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 106,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/106.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/106l.jpg"
                )
            ),
            name: "Itachi Uchiha"
        )
    ),
    AnimeCharacterDTO(
        character: AnimeCharacter(
            characterId: 107,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/characters/10/107.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/characters/10/107l.jpg"
                )
            ),
            name: "Shikamaru Nara"
        )
    )
])

let mockCharacterEntity = mockAnimeCharacterResponse.data.map { $0.toEntity() }
