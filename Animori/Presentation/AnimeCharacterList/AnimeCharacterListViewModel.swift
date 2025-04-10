//
//  AnimeCharacterListViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import Foundation
import ReactorKit

final class AnimeCharacterListViewModel: Reactor {
    
    enum CharacterMode {
        case anime(id: Int)
        case top
    }

    enum Action {
        case loadCharacters
    }
    
    enum Mutation {
        case setTitle(String)
        case setLoading(Bool)
        case setAnimeCharacters([any AnimeCharacterProtocol])
        case setTopCharacters([TopCharacterProtocol])
        case setError(Error)
    }
    
    struct State {
        var title: String = ""
        var isLoading: Bool = false
        var animeCharacters: [any AnimeCharacterProtocol] = []
        var topCharacters: [TopCharacterProtocol] = []
        @Pulse var error: Error? = nil
    }
    
    let initialState: State
    let mode: CharacterMode
    
    init(initialState: State, mode: CharacterMode) {
        self.initialState = initialState
        self.mode = mode
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadCharacters:
            switch action {
            case .loadCharacters:
                let startLoading = Observable.just(Mutation.setLoading(true))
                let stopLoading = Observable.just(Mutation.setLoading(false))
                let titleMutation: Observable<Mutation>
                let request: Observable<Mutation>
                
                switch mode {
                case .anime(let id):
                    titleMutation = Observable.just(Mutation.setTitle("애니메이션 캐릭터"))
                    request = AnimeDetailClient.shared.getAnimeCharacters(id: id)
                        .map { Mutation.setAnimeCharacters($0.data.map { $0.toEntity() }) }
                        .catch { error in
                            Single.just(Mutation.setError(error))
                        }
                        .asObservable()
                    
                    let combinedRequest = Observable.concat([titleMutation, request])
                    return Observable.concat([startLoading, combinedRequest, stopLoading])
                    
                case .top:
                    titleMutation = Observable.just(Mutation.setTitle("Top 캐릭터"))
                    request = AnimeCharacterClient.shared.getTopCharacters()
                        .map { Mutation.setTopCharacters($0.data.map { $0.toEntity() }) }
                        .catch { error in
                            Single.just(Mutation.setError(error))
                        }
                        .asObservable()
                    
                    let combinedRequest = Observable.concat([titleMutation, request])
                    return Observable.concat([startLoading, combinedRequest, stopLoading])
                }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTitle(let title):
            newState.title = title
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setAnimeCharacters(let characters):
            newState.animeCharacters = characters
        case .setTopCharacters(let characters):
            newState.topCharacters = characters
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}

