//
//  AnimeCharacterClient.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation
import RxSwift

final class AnimeCharacterClient {
    
    static let shared = AnimeCharacterClient()
    private let provider = NetworkProvider<AnimeCharacterEndPoint>(rateLimiter: GlobalRateLimiter)
    
    private init() { }
    
    func getTopCharacters() -> Single<TopCharacterResponseDTO> {
        return provider.request(.topCharacter)
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getCharacterPictures(id: Int) -> Single<AnimeCharacterPicturesResponseDTO> {
        return provider.request(.characterPictures(id))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getCharacterById(id: Int) -> Single<AnimeCharacterInfoResponseDTO> {
        return provider.request(.characterInfo(id))
            .catch { error in
                return Single.error(error)
            }
    }
    
    func getCharacterVoiceActors(id: Int) -> Single<AnimeCharacterVoiceActorsResponseDTO> {
        return provider.request(.characterVoiceActors(id))
            .catch { error in
                return Single.error(error)
            }
    }
    
}
