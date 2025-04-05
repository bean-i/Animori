//
//  AnimeClient.swift
//  Animori
//
//  Created by 이빈 on 3/31/25.
//

import Foundation
import RxSwift

final class AnimeClient {
    
    static let shared = AnimeClient()
    private let provider = NetworkProvider<AnimeEndPoint>()
    
    private init() { }
    
    func getTopAnime(query: TopAnimeRequest) -> Single<AnimeResponseDTO> {
        return provider.request(.topAnime(query: query))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getSeasonNow() -> Single<AnimeResponseDTO> {
        return provider.request(.seasonNow)
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getCompleteAnime() -> Single<AnimeResponseDTO> {
        return provider.request(.completeAnime)
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getMovieAnime() -> Single<AnimeResponseDTO> {
        return provider.request(.movieAnime)
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getAnimeSearch(query: String) -> Single<AnimeResponseDTO> {
        return provider.request(.animeSearch(query))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
}
