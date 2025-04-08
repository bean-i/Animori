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
    private let provider = NetworkProvider<AnimeEndPoint>(rateLimiter: GlobalRateLimiter)
    
    private init() { }
    
    func getTopAnime(query: TopAnimeRequest) -> Single<AnimeResponseDTO> {
        return provider.request(.topAnime(query: query))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getSeasonNow() -> Single<AnimeResponseDTO> {
        return provider.request(.seasonNow)
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getCompleteAnime(sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.completeAnime(sortBy))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getMovieAnime(sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.movieAnime(sortBy))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getAnimeSearch(query: String, sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.animeSearch(query, sortBy))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getAnimeGenre(genre: AnimeGenreProtocol, sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.animeByGenre(genre, sortBy))
            .catch { error in
                return Single.error(error)
            }
    }
    
}
