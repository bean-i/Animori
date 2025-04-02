//
//  AnimeDetailMockData.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

let mockAnimeDetailResponse = AnimeDetailResponseDTO(data:
    AnimeDetailDTO(
        id: 58514,
        trailer: AnimeDetailTrailer(
            images: AnimeDetailTrailerImage(
                imageURL: "https://img.youtube.com/vi/3BYutu3Pf_0/sddefault.jpg"
            )
        ),
        titles: [
            AnimeTitle(type: "Japanese", title: "薬屋のひとりごと 第2期"),
            AnimeTitle(type: "English", title: "The Apothecary Diaries Season 2")
        ],
        score: 8.81,
        genres: [
            AnimeGenre(id: 123, name: "Drama"),
            AnimeGenre(id: 1245, name: "Mystery")
        ],
        rating: "PG-13 - Teens 13 or older",
        aired: AnimeDetailAiredDate(
            from: "2025-01-10T00:00:00+00:00",
            to: nil
        ),
        synopsis: """
Using her wit and vast knowledge of medicines and poisons alike, Maomao played a pivotal role in solving a series of mysteries and conspiracies that plagued the imperial court. Having recently come to terms with the secrets of her parents, she returns to fulfill her normal duties on behalf of the emperor's highest-ranking consorts. Maomao also works alongside the eunuch Jinshi to better the consorts' many ladies-in-waiting, including helping them learn to read.

However, with the arrival of a merchant caravan comes a new wave of intrigue. A pattern of strange coincidences involving the visitors and their wares unsettles Maomao, driving her to investigate the puzzling circumstances behind the convoy. As dangers from both outside and within threaten the balance between the imperial concubines, Maomao continues to utilize her cunning and medical expertise to keep the women safe from harm.
""",
        streaming: [
            AnimeDetailOTT(name: "Crunchyroll", url: "https://www.crunchyroll.com/")
        ]
    )
)

let mockAnimeDetailEntity = mockAnimeDetailResponse.data.toEntity()
