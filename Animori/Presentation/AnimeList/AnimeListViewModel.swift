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
        case setSortOptions(ListSortOption)
        case setAnimeList([any AnimeProtocol])
        case setSelectedAnime(Int)
    }
    
    struct State {
        var title: String = ""
        @Pulse var sort: [ListSortOption] = ListSortOption.allCases
        @Pulse var animeList: [any AnimeProtocol]
        @Pulse var selectedSortOption: ListSortOption = .popularity
        @Pulse var selectedAnime: Int?
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimeList(let query):
            switch query {
            case .seasonNow:
                let seasonAnime = AnimeClient.shared.getSeasonNow()
                    .map { $0.data.map { $0.toEntity() } }
                    .map { [weak self] in self?.sortAnimeByPopularity($0) } // 시즌 애니메이션 인기순 정렬 디폴트
                    .compactMap { $0 }
                    .map { Mutation.setAnimeList($0) }
                    .asObservable()
                
                return Observable.merge(
                    seasonAnime,
                    Observable.just(Mutation.setTitle(TitleOption.seasonNow.displayName))
                )
                
            case .completeAnime:
                let completeAnime = AnimeClient.shared.getCompleteAnime()
                    .map { $0.data.map { $0.toEntity() } }
                    .map { [weak self] in self?.sortAnimeByPopularity($0) } // 완결 애니메이션 인기순 정렬 디폴트
                    .compactMap { $0 }
                    .map { Mutation.setAnimeList($0) }
                    .asObservable()
                
                return Observable.merge(
                    completeAnime,
                    Observable.just(Mutation.setTitle(TitleOption.complete.displayName))
                )

            case .movieAnime:
                let movieAnime = AnimeClient.shared.getMovieAnime()
                    .map { $0.data.map { $0.toEntity() } }
                    .map { Mutation.setAnimeList($0) }
                    .asObservable()
                
                return Observable.merge(
                    movieAnime,
                    Observable.just(Mutation.setTitle(TitleOption.movie.displayName))
                )
            
            case .animeSearch(let query):
                let searchAnime = AnimeClient.shared.getAnimeSearch(query: query)
                    .map { $0.data.map { $0.toEntity() } }
                    .map { Mutation.setAnimeList($0) }
                    .asObservable()
                
                return Observable.merge(
                    searchAnime,
                    Observable.just(Mutation.setTitle(query))
                )
                
            default:
                return Observable.just(Mutation.setAnimeList([]))
            }
            
        case .sortSelected(let sortOption):
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                Observable.just(Mutation.setAnimeList(sortAnimeList(sortOption)))
            )

        case .animeSelected(let id):
            return Observable.just(Mutation.setSelectedAnime(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSortOptions(let listSortOption):
            newState.selectedSortOption = listSortOption
        case .setAnimeList(let animeList):
            newState.animeList = animeList
        case .setSelectedAnime(let id):
            newState.selectedAnime = id
        case .setTitle(let title):
            newState.title = title
        }
        return newState
    }

    private func sortAnimeList(_ sortOption: ListSortOption) -> [any AnimeProtocol] {
        switch sortOption {
        case .popularity:
            return currentState.animeList.sorted { $0.popularity > $1.popularity }
        case .favorites:
            return currentState.animeList.sorted { $0.favorites > $1.favorites }
        case .score:
            return currentState.animeList.sorted { $0.rate > $1.rate }
        }
    }
    
    private func sortAnimeByPopularity(_ anime: [any AnimeProtocol]) -> [any AnimeProtocol] {
        return anime.sorted { $0.popularity > $1.popularity }
    }
    
}
