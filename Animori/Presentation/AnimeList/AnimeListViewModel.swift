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
   
    enum Action {
        case loadAnimeList(AnimeEndPoint)
        case sortSelected(ListSortOption)
        case animeSelected(Int)
    }
    
    enum Mutation {
        case setTitle(String)
        case setCurrentEndpoint(AnimeEndPoint)
        case setSortOptions(ListSortOption)
        case setAnimeList([any AnimeProtocol])
        case setSelectedAnime(Int)
    }
    
    struct State {
        var title: String = ""
        var currentEndpoint: AnimeEndPoint?
        @Pulse var sort: [ListSortOption] = ListSortOption.allCases
        @Pulse var animeList: [any AnimeProtocol]
        @Pulse var selectedSortOption: ListSortOption = .scoredBy
        @Pulse var selectedAnime: Int?
    }
    
    let initialState: State
    private var currentEndpoint: AnimeEndPoint?
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimeList(let query):
            currentEndpoint = query
            return Observable.merge(
                requestAnimeList(endpoint: query, sortBy: .scoredBy),
                Observable.just(Mutation.setCurrentEndpoint(query)) // 추가
            )
            
        case .sortSelected(let sortOption):
            print("정렬 새로 선택됨", sortOption)
            guard let endpoint = currentEndpoint else {
                return Observable.empty()
            }
            
            let newAnimeList = requestAnimeList(endpoint: endpoint, sortBy: sortOption)
            
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                newAnimeList
            )

        case .animeSelected(let id):
            return Observable.just(Mutation.setSelectedAnime(id))
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
            
            return Observable.merge(
                seasonAnime,
                Observable.just(Mutation.setTitle(TitleOption.seasonNow.displayName))
            )
            
        case .completeAnime:
            let completeAnime = AnimeClient.shared.getCompleteAnime(sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .asObservable()
            
            return Observable.merge(
                completeAnime,
                Observable.just(Mutation.setTitle(TitleOption.complete.displayName))
            )

        case .movieAnime:
            let movieAnime = AnimeClient.shared.getMovieAnime(sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .asObservable()
            
            return Observable.merge(
                movieAnime,
                Observable.just(Mutation.setTitle(TitleOption.movie.displayName))
            )
        
        case .animeSearch(let query, _):
            let searchAnime = AnimeClient.shared.getAnimeSearch(query: query, sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .asObservable()
            
            return Observable.merge(
                searchAnime,
                Observable.just(Mutation.setTitle(query))
            )
            
        case .animeByGenre(let genre, _):
            let genreAnime = AnimeClient.shared.getAnimeGenre(genre: genre, sortBy: sortBy)
                .map { $0.data.map { $0.toEntity() } }
                .map { Mutation.setAnimeList($0) }
                .asObservable()
            
            return Observable.merge(
                genreAnime,
                Observable.just(Mutation.setTitle("\(genre.name) 애니메이션"))
            )
            
        default:
            return Observable.just(Mutation.setAnimeList([]))
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
}
