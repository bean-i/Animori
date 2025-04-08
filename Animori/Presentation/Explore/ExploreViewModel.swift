//
//  ExploreViewModel.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation
import RxSwift
import ReactorKit

final class ExploreViewModel: Reactor {
   
    enum Action {
        case loadAnime
        case sortSelected(SortOption)
        case animeSelected(Int)
    }
    
    enum Mutation {
        case setSortOptions(SortOption)
        case setTopAnime([any AnimeProtocol])
        case setSeasonAnime([any AnimeProtocol])
        case setCompleteAnime(([any AnimeProtocol]))
        case setMovieAnime(([any AnimeProtocol]))
        case setSelectedAnime(Int)
        case setError(Error)
    }
    
    struct State {
        var sort: [SortOption] = SortOption.allCases // 정렬 버튼
        @Pulse var topAnime: [any AnimeProtocol] // 탑인기 애니메이션
        @Pulse var seasonAnime: [any AnimeProtocol] // 이번 시즌 애니메이션
        @Pulse var completeAnime: [any AnimeProtocol] // 완결 명작 애니메이션
        @Pulse var movieAnime: [any AnimeProtocol] // 영화 애니메이션
        var selectedSortOption: SortOption = .popular
        @Pulse var selectedAnime: Int?
        @Pulse var error: Error? = nil
    }
    
    var isLoading = false
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnime:
            if isLoading { return Observable.empty() }
            isLoading = true
            
            let topAnime = AnimeClient.shared.getTopAnime(query: TopAnimeRequest.basic)
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setTopAnime($0) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let seasonAnime = AnimeClient.shared.getSeasonNow()
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setSeasonAnime($0) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let completeAnime = AnimeClient.shared.getCompleteAnime(sortBy: .scoredBy)
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setCompleteAnime($0) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            let movieAnime = AnimeClient.shared.getMovieAnime(sortBy: .scoredBy)
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setMovieAnime($0) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()
            
            return Observable.merge(topAnime, seasonAnime, completeAnime, movieAnime)
                .do(onCompleted: { [weak self] in self?.isLoading = false })
            
        case .sortSelected(let sortOption):
            let newTopAnime = sortTopAnime(sortOption)
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                newTopAnime
            )

        case .animeSelected(let id):
            return Observable.just(Mutation.setSelectedAnime(id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSortOptions(let sortOption):
            newState.selectedSortOption = sortOption
        case .setTopAnime(let anime):
            newState.topAnime = anime
        case .setSeasonAnime(let anime):
            newState.seasonAnime = anime
        case .setCompleteAnime(let anime):
            newState.completeAnime = anime
        case .setMovieAnime(let anime):
            newState.movieAnime = anime
        case .setSelectedAnime(let id):
            newState.selectedAnime = id
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
    
    private func sortTopAnime(_ sortOption: SortOption) -> Observable<Mutation> {
        let newQuery = TopAnimeRequest(filter: sortOption.apiParameter, limit: 10)
        return AnimeClient.shared.getTopAnime(query: newQuery)
            .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
            .map { Mutation.setTopAnime($0) }
            .catch { error in
                return Single.just(Mutation.setError(error))
            }
            .asObservable()
    }
}
