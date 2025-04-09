//
//  AnimeDetailResponseDTO.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

// MARK: - Response
struct AnimeDetailResponseDTO: Decodable {
    let data: AnimeDetailDTO
}

struct AnimeDetailDTO: Decodable, TitleSelectable {
    let id: Int
    let trailer: AnimeDetailTrailer
    let images: AnimeImage
    let titles: [AnimeTitle]
    let score: Double?
    let genres: [AnimeGenre]
    let rating: String?
    let aired: AnimeDetailAiredDate
    let synopsis: String?
    let streaming: [AnimeDetailOTT]
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case trailer, images, titles, score, genres, rating, aired, synopsis, streaming
    }
}

struct AnimeDetailTrailer: Decodable {
    let images: AnimeDetailTrailerImage
}

struct AnimeDetailTrailerImage: Decodable {
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "small_image_url"
    }
}

struct AnimeDetailAiredDate: Decodable {
    let from: String?
    let to: String? // Date ISO8601
}

struct AnimeDetailOTT: Decodable, Equatable {
    let name: String
    let url: String
}

// MARK: - AnimeDetailResponseDTO Extension: empty data
extension AnimeDetailResponseDTO {
    static var empty: AnimeDetailResponseDTO {
        return AnimeDetailResponseDTO(data: AnimeDetailDTO.empty)
    }
}

// MARK: - AnimeDetailDTO Extension: empty data
extension AnimeDetailDTO {
    static var empty: AnimeDetailDTO {
        return AnimeDetailDTO(
            id: 0,
            trailer: AnimeDetailTrailer(images: AnimeDetailTrailerImage(imageURL: "")),
            images: AnimeImage(jpg: AnimeJPG(imageURL: "", largeImageURL: "")),
            titles: [],
            score: 0,
            genres: [],
            rating: "",
            aired: AnimeDetailAiredDate(from: "", to: ""),
            synopsis: "",
            streaming: []
        )
    }
}

// MARK: - AnimeDetailDTO Extension: toEntity
extension AnimeDetailDTO {
    func toEntity() -> AnimeDetailEntity {
        let preferredTitle = self.preferredTitle()
        
        // 대체 불가 이미지 URL
        var image = self.trailer.images.imageURL
        if image == nil {
            image = self.images.jpg.largeImageURL
        }

        // 장르에 해시태그 추가
        let genre = self.genres.map { "#\($0.name)" }
        
        // 평점 없을 경우 "N/A"
        let rate = self.score.map { String($0) } ?? "N/A"
        
        // 연령 등급
        let age = self.rating ?? "연령 정보 없음"
        
        // 방영 기간 처리
        let startDate = DateFormatter.isoToYMD(aired.from)
        let endDate = DateFormatter.isoToYMD(aired.to)
        let airedPeriod = "\(startDate) ~ \(endDate)"
        
        // 시놉시스
        let plot = self.synopsis ?? "줄거리 정보 없음"
        
        return AnimeDetailEntity(
            id: self.id,
            title: preferredTitle,
            image: image ?? "",
            genre: genre,
            rate: rate,
            age: age,
            airedPeriod: airedPeriod,
            plot: plot,
            OTT: self.streaming
        )
    }
}
