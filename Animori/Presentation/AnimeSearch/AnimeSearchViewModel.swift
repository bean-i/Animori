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
        case search(String)
        case genreSelected(Int)
        case removeRecentSearch(String, String)
    }
    
    enum Mutation {
        case setRecentKeywords([RecentSearchTable])
        case setSearchedKeyword(String)
        case setGenres([any AnimeGenreProtocol])
        case setTopAnimes([any AnimeProtocol])
        case setTopCharacters([any TopCharacterProtocol])
        case setGenreSelected(Int)
    }
    
    struct State {
        @Pulse var recentKeywords: [RecentSearchTable] = []
        @Pulse var searchedKeyword: String? = nil
        var genres: [any AnimeGenreProtocol] = []
        var topAnimes: [any AnimeProtocol] = []
        var topCharacters: [any TopCharacterProtocol] = []
        @Pulse var selectedGenre: Int?
    }
    
    private let recentSearchRepository = RecentSearchRepository()
    let initialState: State
    
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

            let keywords = Array(recentSearchRepository.fetchAll())

            return Observable.merge(
                Observable.just(Mutation.setRecentKeywords(keywords)),
                genres,
                topAnime,
                topCharacters
            )
            
        case .search(let keyword):
            let table = RecentSearchTable(keyword: keyword, timestamp: Date())
            recentSearchRepository.create(data: table)
            return Observable.merge(
                Observable.just(Mutation.setRecentKeywords(recentSearchRepository.fetchAll())),
                Observable.just(Mutation.setSearchedKeyword(keyword))  // 새 mutation 추가
            )

        case .removeRecentSearch(let id, _):
            recentSearchRepository.delete(id: id)
            return Observable.just(Mutation.setRecentKeywords(recentSearchRepository.fetchAll()))

        case .genreSelected(let genreID):
            return Observable.just(Mutation.setGenreSelected(genreID))
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
        case .setGenreSelected(let genreID):
            newState.selectedGenre = genreID
        case .setSearchedKeyword(let keyword):
            newState.searchedKeyword = keyword
        }
        return newState
    }
}
