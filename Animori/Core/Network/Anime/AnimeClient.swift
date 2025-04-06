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
    
    func getCompleteAnime(sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.completeAnime(sortBy))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getMovieAnime(sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.movieAnime(sortBy))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getAnimeSearch(query: String, sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.animeSearch(query, sortBy))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
    func getAnimeGenre(genreID: String, sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.animeByGenre(genreID, sortBy))
            .catch { error in
                return Single.just(AnimeResponseDTO.empty)
            }
    }
    
}
