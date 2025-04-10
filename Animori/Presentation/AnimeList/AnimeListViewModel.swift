//
//  AnimeListViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation
import RxSwift
import ReactorKit

final class AnimeListViewModel: Reactor {
    
    enum AnimeMode {
        case anime
        case top
    }
   
    enum Action {
        case loadAnimeList(AnimeEndPoint)
        case sortSelected(ListSortOption)
        case topSortSelected(SortOption)
        case animeSelected(Int)
    }
    
    enum Mutation {
        case setTitle(String)
        case setCurrentEndpoint(AnimeEndPoint)
        case setSortOptions(ListSortOption)
        case setTopSortOptions(SortOption)
        case setAnimeList([any AnimeProtocol])
        case setSelectedAnime(Int)
        case setError(Error)
    }
    
    struct State {
        var title: String = ""
        var currentEndpoint: AnimeEndPoint
        @Pulse var topSort: [SortOption] = SortOption.allCases
        @Pulse var sort: [ListSortOption] = ListSortOption.allCases
        @Pulse var animeList: [any AnimeProtocol] = []
        @Pulse var selectedSortOption: ListSortOption = .scoredBy
        @Pulse var selectedTopSortOption: SortOption = .popular
        @Pulse var selectedAnime: Int?
        @Pulse var error: Error? = nil
    }
    
    let initialState: State
    let mode: AnimeMode
    
    init(initialState: State, mode: AnimeMode) {
        self.initialState = initialState
        self.mode = mode
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimeList(let query):
            return Observable.merge(
                requestAnimeList(endpoint: query, sortBy: .scoredBy)
            )
            
        case .sortSelected(let sortOption):
            let newAnimeList = requestAnimeList(endpoint: currentState.currentEndpoint, sortBy: sortOption)
            
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                newAnimeList
            )

        case .animeSelected(let id):
            return Observable.just(Mutation.setSelectedAnime(id))
            
        case .topSortSelected(let option):
            let newTopAnime = sortTopAnime(option)
            return Observable.merge(
                Observable.just(Mutation.setTopSortOptions(option)),
                newTopAnime
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTitle(let title):
            newState.title = title
        case .setCurrentEndpoint(let endpoint): // 추가
            newState.currentEndpoint = endpoint
        case .setSortOptions(let listSortOption):
            newState.selectedSortOption = listSortOption
        case .setAnimeList(let animeList):
            newState.animeList = animeList
        case .setSelectedAnime(let id):
            newState.selectedAnime = id
        case .setError(let error):
            newState.error = error
        case .setTopSortOptions(let option):
            newState.selectedTopSortOption = option
        }
        return newState
    }
    
    // 네트워크 통신
    private func requestAnimeList(endpoint: AnimeEndPoint, sortBy: ListSortOption) -> Observable<Mutation> {
        switch endpoint {
        case .seasonNow:
            let seasonAnime = AnimeClient.shared.getSeasonNow()
                .map { $0.data.map { $0.toEntity() } }
                .map { [weak self] in self?.sortAnimeByPopularity($0) }
                .compactMap { $0 }
                .map { Mutation.setAnimeList($0) }
                .asObservable()
                .catch { error -> Observable<Mutation> in
                    return Observable.just(Mutation.setError(error))
                }
            
            return Observable.merge(
                seasonAnime,
                Observable.just(Mutation.setTitle(TitleOption.seasonNow.displayName))
            )
            
        case .completeAnime:
            let completeAnime = AnimeClient.shared.getCompleteAnime(sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .catch { error in
                    return Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(
                completeAnime,
                Observable.just(Mutation.setTitle(TitleOption.complete.displayName))
            )

        case .movieAnime:
            let movieAnime = AnimeClient.shared.getMovieAnime(sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .catch { error in
                    return Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(
                movieAnime,
                Observable.just(Mutation.setTitle(TitleOption.movie.displayName))
            )
        
        case .animeSearch(let query, _):
            let searchAnime = AnimeClient.shared.getAnimeSearch(query: query, sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .catch { error in
                    return Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(
                searchAnime,
                Observable.just(Mutation.setTitle(query))
            )
            
        case .animeByGenre(let genre, _):
            let genreAnime = AnimeClient.shared.getAnimeGenre(genre: genre, sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .catch { error in
                    return Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(
                genreAnime,
                Observable.just(Mutation.setTitle("\(genre.name) \(LocalizedStrings.AnimeList.anime)"))
            )
            
        case .topAnime(let query):
            let topAnime = AnimeClient.shared.getTopAnime(query: query)
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setAnimeList($0) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(
                topAnime,
                Observable.just(Mutation.setTitle(TitleOption.topAnime.displayName))
            )
        }
    }

    private func sortAnimeList(_ sortOption: ListSortOption) -> [any AnimeProtocol] {
        switch sortOption {
        case .scoredBy:
            return currentState.animeList.sorted { $0.scoredBy > $1.scoredBy }
        case .favorites:
            return currentState.animeList.sorted { $0.favorites > $1.favorites }
        case .score:
            return currentState.animeList.sorted { $0.rate > $1.rate }
        }
    }
    
    private func sortAnimeByPopularity(_ anime: [any AnimeProtocol]) -> [any AnimeProtocol] {
        return anime.sorted { $0.scoredBy > $1.scoredBy }
    }
    
    private func sortTopAnime(_ sortOption: SortOption) -> Observable<Mutation> {
        let newQuery = TopAnimeRequest(filter: sortOption.apiParameter, limit: 25)
        return AnimeClient.shared.getTopAnime(query: newQuery)
            .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
            .map { Mutation.setAnimeList($0) }
            .catch { error in
                return Single.just(Mutation.setError(error))
            }
            .asObservable()
    }
}
