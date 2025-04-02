//
//  AnimeReviewMockData.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

let mockReviewResponse = AnimeReviewResponseDTO(data: [
    AnimeReviewDTO(
        review: "Amazing continuation of the story with great character development and visuals.",
        score: 9,
        user: AnimeReviewUser(
            username: "animeFan123",
            images: AnimeReviewUserImage(
                jpg: AnimeReviewUserImageJPG(
                    imageURL: "https://cdn.myanimelist.net/images/userimages/123456.jpg"
                )
            )
        )
    ),
    AnimeReviewDTO(
        review: "The pacing felt a bit slow in the middle, but overall a solid season.",
        score: 7,
        user: AnimeReviewUser(
            username: "otakuQueen",
            images: AnimeReviewUserImage(
                jpg: AnimeReviewUserImageJPG(
                    imageURL: "https://cdn.myanimelist.net/images/userimages/789012.jpg"
                )
            )
        )
    ),
    AnimeReviewDTO(
        review: "Visually stunning and emotionally engaging. Highly recommend!",
        score: 10,
        user: AnimeReviewUser(
            username: "MALUser42",
            images: AnimeReviewUserImage(
                jpg: AnimeReviewUserImageJPG(
                    imageURL: "https://cdn.myanimelist.net/images/userimages/345678.jpg"
                )
            )
        )
    )
])

let mockReviewEntity = mockReviewResponse.data.map { $0.toEntity() }
