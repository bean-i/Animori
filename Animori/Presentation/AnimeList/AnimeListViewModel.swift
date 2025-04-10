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
        case loadNextPage
    }
    
    enum Mutation {
        case setTitle(String)
        case setCurrentEndpoint(AnimeEndPoint)
        case setSortOptions(ListSortOption)
        case setTopSortOptions(SortOption)
        case setAnimeList([any AnimeProtocol])
        case appendAnimeList([any AnimeProtocol])
        case setSelectedAnime(Int)
        case setError(Error)
        case setPagination(currentPage: Int, lastPage: Int, hasNextPage: Bool)
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
        
        // 페이지네이션
        @Pulse var currentPage: Int = 1
        @Pulse var lastPage: Int = 1
        @Pulse var hasNextPage: Bool = false
        @Pulse var isLoadingPage: Bool = false
    }
    
    let initialState: State
    let mode: AnimeMode
    
    init(initialState: State, mode: AnimeMode) {
        self.initialState = initialState
        self.mode = mode
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnimeList(let endpoint):
            switch endpoint {
            case .animeByGenre:
                return requestAnimeList(endpoint: endpoint, sortBy: currentState.selectedSortOption, page: nil, append: false)
            default:
                return requestAnimeList(endpoint: endpoint, sortBy: .scoredBy, page: 1, append: false)
            }
            
        case .loadNextPage:
            guard currentState.hasNextPage, !currentState.isLoadingPage else {
                return Observable.empty()
            }
            let nextPage = currentState.currentPage + 1
            return requestAnimeList(endpoint: currentState.currentEndpoint, sortBy: currentState.selectedSortOption, page: nextPage, append: true)
            
        case .sortSelected(let sortOption):
            let newEndpoint: AnimeEndPoint
            switch currentState.currentEndpoint {
            case .completeAnime(_, _):
                newEndpoint = .completeAnime(sortOption: sortOption, page: 1)
            case .movieAnime(_, _):
                newEndpoint = .movieAnime(sortOption: sortOption, page: 1)
            case .animeSearch(let query, _, _):
                newEndpoint = .animeSearch(query: query, sortOption: sortOption, page: 1)
            default:
                newEndpoint = currentState.currentEndpoint // 다른 경우는 그대로 사용
            }
            
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                requestAnimeList(endpoint: newEndpoint, sortBy: sortOption, page: 1, append: false)
            )
            
        case .topSortSelected(let option):
            let newEndpoint: AnimeEndPoint = .topAnime(sortOption: option, page: 1)
            return Observable.merge(
                Observable.just(Mutation.setTopSortOptions(option)),
                sortTopAnime(option)
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
        case .setCurrentEndpoint(let endpoint):
            newState.currentEndpoint = endpoint
        case .setSortOptions(let sortOption):
            newState.selectedSortOption = sortOption
        case .setTopSortOptions(let option):
            newState.selectedTopSortOption = option
        case .setAnimeList(let animeList):
            newState.animeList = animeList
        case .appendAnimeList(let additionalAnime):
            newState.animeList += additionalAnime
        case .setSelectedAnime(let id):
            newState.selectedAnime = id
        case .setError(let error):
            newState.error = error
        case .setPagination(let currentPage, let lastPage, let hasNextPage):
            newState.currentPage = currentPage
            newState.lastPage = lastPage
            newState.hasNextPage = hasNextPage
            newState.isLoadingPage = false
        }
        return newState
    }

    private func requestAnimeList(endpoint: AnimeEndPoint, sortBy: ListSortOption, page: Int?, append: Bool) -> Observable<Mutation> {
        
        func buildObservable(from single: Single<AnimeResponseDTO>) -> Observable<Mutation> {
            return single
                .asObservable()
                .map { response in
                    let animeEntities = response.data.map { $0.toEntity() }
                    return (animeEntities, response.pagination)
                }
                .flatMap { animeEntities, pagination -> Observable<Mutation> in
                    let listMutation: Mutation = append ?
                        .appendAnimeList(animeEntities) :
                        .setAnimeList(animeEntities)
                    
                    let paginationMutation = Mutation.setPagination(
                        currentPage: pagination.currentPage,
                        lastPage: pagination.lastVisiblePage,
                        hasNextPage: pagination.hasNextPage
                    )
                    return Observable.of(listMutation, paginationMutation)
                }
                .catch { error -> Observable<Mutation> in
                    return Observable.just(Mutation.setError(error))
                }
        }
        
        switch endpoint {
        case .seasonNow(_):
            let seasonAnime = buildObservable(from: AnimeClient.shared.getSeasonNow(page: page ?? 1))
            return Observable.merge(
                seasonAnime,
                Observable.just(Mutation.setTitle(TitleOption.seasonNow.displayName))
            )
            
        case .completeAnime(let sortOption, _):
            let completeAnime = buildObservable(from: AnimeClient.shared.getCompleteAnime(sortBy: sortOption, page: page ?? 1))
            return Observable.merge(
                completeAnime,
                Observable.just(Mutation.setTitle(TitleOption.complete.displayName))
            )
            
        case .movieAnime(let sortOption, _):
            let movieAnime = buildObservable(from: AnimeClient.shared.getMovieAnime(sortBy: sortOption, page: page ?? 1))
            return Observable.merge(
                movieAnime,
                Observable.just(Mutation.setTitle(TitleOption.movie.displayName))
            )
            
        case .animeSearch(let query, let sortOption, _):
            let searchAnime = buildObservable(from: AnimeClient.shared.getAnimeSearch(query: query, sortBy: sortOption, page: page!))
            return Observable.merge(
                searchAnime,
                Observable.just(Mutation.setTitle(query))
            )
            
        case .animeByGenre(let genre, let sortOption):
            let genreAnime = buildObservable(from: AnimeClient.shared.getAnimeGenre(genre: genre, sortBy: sortOption))
            return Observable.merge(
                genreAnime,
                Observable.just(Mutation.setTitle("\(genre.name) \(LocalizedStrings.AnimeList.anime)"))
            )
            
        case .topAnime(let sortOption, _):
            // 최신 엔드포인트: .topAnime(sortOption: SortOption, page: Int)
            let topAnime = buildObservable(from: AnimeClient.shared.getTopAnime(sortOption: sortOption, page: page!))
            return Observable.merge(
                topAnime,
                Observable.just(Mutation.setTitle(TitleOption.topAnime.displayName))
            )
        }
    }
    
    private func sortTopAnime(_ sortOption: SortOption) -> Observable<Mutation> {
        let topAnimeObservable = AnimeClient.shared.getTopAnime(sortOption: sortOption, page: 1)
        return topAnimeObservable
            .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
            .map { Mutation.setAnimeList($0) }
            .catch { error in
                return Single.just(Mutation.setError(error))
            }
            .asObservable()
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
