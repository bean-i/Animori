//
//  AnimeRecommendMockData.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

let mockAnimeRecommendResponse = AnimeRecommendResponseDTO(data: [
    AnimeRecommendDTO(
        entry: AnimeRecommendInfoDTO(
            id: 5114,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/anime/5/73399.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/anime/5/73399l.jpg"
                )
            ),
            title: "Fullmetal Alchemist: Brotherhood"
        )
    ),
    AnimeRecommendDTO(
        entry: AnimeRecommendInfoDTO(
            id: 9253,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/anime/13/17405.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/anime/13/17405l.jpg"
                )
            ),
            title: "Steins;Gate"
        )
    ),
    AnimeRecommendDTO(
        entry: AnimeRecommendInfoDTO(
            id: 11061,
            images: AnimeImage(
                jpg: AnimeJPG(
                    imageURL: "https://cdn.myanimelist.net/images/anime/10/48865.jpg",
                    largeImageURL: "https://cdn.myanimelist.net/images/anime/10/48865l.jpg"
                )
            ),
            title: "Hunter x Hunter (2011)"
        )
    )
])

let mockRecommendEntities = mockAnimeRecommendResponse.data.map { $0.toEntity() }
