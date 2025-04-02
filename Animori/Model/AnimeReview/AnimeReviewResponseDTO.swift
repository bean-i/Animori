//
//  AnimeReviewResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

struct AnimeReviewResponseDTO: Decodable {
    let data: [AnimeReviewDTO]
}

struct AnimeReviewDTO: Decodable {
    let review: String
    let score: Int
    let user: AnimeReviewUser
}

struct AnimeReviewUser: Decodable {
    let username: String
    let images: AnimeReviewUserImage
}

struct AnimeReviewUserImage: Decodable {
    let jpg: AnimeReviewUserImageJPG
}

struct AnimeReviewUserImageJPG: Decodable {
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}

// MARK: - AnimeDetailResponseDTO Extension: empty data
extension AnimeReviewResponseDTO {
    static var empty: AnimeReviewResponseDTO {
        return AnimeReviewResponseDTO(data: [])
    }
}

// MARK: - AnimeDetailDTO Extension: empty data
extension AnimeReviewDTO {
    static var empty: AnimeReviewDTO {
        return AnimeReviewDTO(
            review: "",
            score: 0,
            user: AnimeReviewUser(
                username: "",
                images: AnimeReviewUserImage(jpg: AnimeReviewUserImageJPG(imageURL: ""))
            )
        )
    }
}

// MARK: - AnimeDetailDTO Extension: toEntity
extension AnimeReviewDTO {
    func toEntity() -> any AnimeReviewProtocol {
        return AnimeReviewEntity(name: self.user.username, score: "\(self.score)", review: self.review)
    }
}
