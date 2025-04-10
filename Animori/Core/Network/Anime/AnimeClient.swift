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
    
    func getTopAnime(sortOption: SortOption, page: Int) -> Single<AnimeResponseDTO> {
        return provider.request(.topAnime(sortOption: sortOption, page: page))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getSeasonNow(page: Int) -> Single<AnimeResponseDTO> {
        return provider.request(.seasonNow(page: page))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getCompleteAnime(sortBy: ListSortOption, page: Int) -> Single<AnimeResponseDTO> {
        return provider.request(.completeAnime(sortOption: sortBy, page: page))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getMovieAnime(sortBy: ListSortOption, page: Int) -> Single<AnimeResponseDTO> {
        return provider.request(.movieAnime(sortOption: sortBy, page: page))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getAnimeSearch(query: String, sortBy: ListSortOption, page: Int) -> Single<AnimeResponseDTO> {
        return provider.request(.animeSearch(query: query, sortOption: sortBy, page: page))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getAnimeGenre(genre: AnimeGenreProtocol, sortBy: ListSortOption) -> Single<AnimeResponseDTO> {
        return provider.request(.animeByGenre(genre: genre, sortOption: sortBy))
            .catch { error in
                return Single.error(error)
            }
    }
}
