//
//  AnimeCharacterDetailViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import Foundation
import ReactorKit

final class AnimeCharacterDetailViewModel: Reactor {
    
    enum Action {
        case loadInfo
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setCharacterPictures([AnimeCharacterPicturesProtocol])
        case setCharacterInfo(AnimeCharacterInfoProtocol)
        case setCharacterVoiceActors([AnimeCharacterVoiceActorsProtocol])
        case setError(Error)
    }
    
    struct State {
        @Pulse var isLoading: Bool = false
        var characterPictures: [AnimeCharacterPicturesProtocol] = []
        var characterInfo: AnimeCharacterInfoProtocol = AnimeCharacterInfoDTO.empty.toEntity()
        var characterVoiceActors: [AnimeCharacterVoiceActorsProtocol] = []
        @Pulse var error: Error? = nil
    }
    
    private let characterID: Int
    let initialState: State
    
    init(initialState: State, characterID: Int) {
        self.initialState = initialState
        self.characterID = characterID
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadInfo:
            let startLoading = Observable.just(Mutation.setLoading(true))
            
            let characterPictures = AnimeCharacterClient.shared.getCharacterPictures(id: characterID)
                .map { Mutation.setCharacterPictures($0.data.map { $0.toEntity() }) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let characterInfo = AnimeCharacterClient.shared.getCharacterById(id: characterID)
                .map { Mutation.setCharacterInfo($0.data.toEntity()) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let characterVoiceActors = AnimeCharacterClient.shared.getCharacterVoiceActors(id: characterID)
                .map { Mutation.setCharacterVoiceActors($0.data.map { $0.toEntity() }) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let networkRequests = Observable.merge(characterPictures, characterInfo, characterVoiceActors)
            let finishLoading = Observable.just(Mutation.setLoading(false))
            
            return Observable.concat(
                startLoading,
                networkRequests,
                finishLoading
            )
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let bool): newState.isLoading = bool
        case .setCharacterPictures(let pictures): newState.characterPictures = pictures
        case .setCharacterInfo(let info): newState.characterInfo = info
        case .setCharacterVoiceActors(let actors): newState.characterVoiceActors = actors
        case .setError(let error): newState.error = error
        }
        return newState
    }
    
}
