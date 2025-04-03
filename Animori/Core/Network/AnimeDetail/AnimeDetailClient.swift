//
//  AnimeDetailClient.swift
//  Animori
//
//  Created by 이빈 on 4/3/25.
//

import Foundation
import RxSwift

final class AnimeDetailClient {
    
    static let shared = AnimeDetailClient()
    private let provider = NetworkProvider<AnimeDetailEndPoint>()
    
    private init() { }

    func getAnimeFullById(id: Int) -> Single<AnimeDetailResponseDTO> {
        return provider.request(.fullAnimeInfo(id))
            .catch { error in
                return Single.just(AnimeDetailResponseDTO.empty)
            }
    }
    
    func getAnimeReviews(id: Int) -> Single<AnimeReviewResponseDTO> {
        return provider.request(.animeReviews(id))
            .catch { error in
                return Single.just(AnimeReviewResponseDTO.empty)
            }
    }
    
    func getAnimeRecommendations(id: Int) -> Single<AnimeRecommendResponseDTO> {
        return provider.request(.animeRecommendations(id))
            .catch { error in
                return Single.just(AnimeRecommendResponseDTO.empty)
            }
    }
    
    func getAnimeCharacters(id: Int) -> Single<AnimeCharacterResponseDTO> {
        return provider.request(.animeCharacters(id))
            .catch { error in
                return Single.just(AnimeCharacterResponseDTO.empty)
            }
    }
    
}
