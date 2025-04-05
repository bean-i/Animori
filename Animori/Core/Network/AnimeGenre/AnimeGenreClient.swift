//
//  AnimeGenreClient.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation
import RxSwift

final class AnimeGenreClient {
    
    static let shared = AnimeGenreClient()
    private let provider = NetworkProvider<AnimeGenreEndPoint>()
    
    private init() { }
    
    func getAnimeGenres() -> Single<AnimeGenreResponseDTO> {
        return provider.request(.genres)
            .catch { error in
                return Single.just(AnimeGenreResponseDTO.empty)
            }
    }
    
}
