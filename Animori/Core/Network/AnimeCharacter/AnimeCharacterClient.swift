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
    private let provider = NetworkProvider<AnimeCharacterEndPoint>()
    
    private init() { }
    
    func getTopCharacters() -> Single<TopCharacterResponseDTO> {
        return provider.request(.topCharacter)
            .catch { error in
                return Single.just(TopCharacterResponseDTO.empty)
            }
    }
    
}
