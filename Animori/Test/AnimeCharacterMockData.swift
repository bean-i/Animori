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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/3/37/Sakura_Haruno.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/2/27/Naruto_Uzumaki.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/4/4d/Sasuke_Uchiha.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/7/7a/Kakashi_Hatake.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/9/9f/Hinata_Hyuga.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/8/8a/Itachi_Uchiha.png"
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
                    imageURL: "https://picsum.photos/200/300",
                    largeImageURL: "https://static.nocookie.net/naruto/images/5/52/Shikamaru_Nara.png"
                )
            ),
            name: "Shikamaru Nara"
        )
    )
])

let mockCharacterEntity = mockAnimeCharacterResponse.data.map { $0.toEntity() }

