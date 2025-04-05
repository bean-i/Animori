//
//  AnimeSearchViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation
import RxSwift
import ReactorKit

final class AnimeSearchViewModel: Reactor {
    
    enum Action {
        case loadInfo // 최근 검색어, 장르, 탑애니메이션, 탑캐릭터 다 로드
    }
    
    enum Mutation {
        case setRecentKeywords([String])
        case setGenres([any AnimeGenreProtocol])
        case setTopAnimes([any AnimeProtocol])
        case setTopCharacters([any TopCharacterProtocol])
    }
    
    struct State {
        var recentKeywords: [String] = []
        var genres: [any AnimeGenreProtocol] = []
        var topAnimes: [any AnimeProtocol] = []
        var topCharacters: [any TopCharacterProtocol] = []
    }
    
    let initialState: State
    
    var keywords = ["asdf", "482", "sdf", "gjlgk", "fwijorij", "rejhdsfjh", "sdlkjf"]
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadInfo:
            let topAnime = AnimeClient.shared.getTopAnime(query: TopAnimeRequest.basic)
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setTopAnimes($0) }
                .asObservable()

            let topCharacters = AnimeCharacterClient.shared.getTopCharacters()
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setTopCharacters($0) }
                .asObservable()
            
            let genres = AnimeGenreClient.shared.getAnimeGenres()
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setGenres($0) }
                .asObservable()
            
            return Observable.merge(
                Observable.just(Mutation.setRecentKeywords(keywords)),
                genres,
                topAnime,
                topCharacters
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRecentKeywords(let keywords):
            newState.recentKeywords = keywords
        case .setGenres(let genres):
            newState.genres = genres
        case .setTopAnimes(let animes):
            newState.topAnimes = animes
        case .setTopCharacters(let characters):
            newState.topCharacters = characters
        }
        return newState
    }
}
