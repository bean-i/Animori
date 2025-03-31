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
    }
    
    struct State {
        var sort: [SortOption] = SortOption.allCases // 정렬 버튼
        @Pulse var topAnime: [any AnimeProtocol] // 탑인기 애니메이션
        @Pulse var seasonAnime: [any AnimeProtocol] // 이번 시즌 애니메이션
        @Pulse var completeAnime: [any AnimeProtocol] // 완결 명작 애니메이션
        @Pulse var movieAnime: [any AnimeProtocol] // 영화 애니메이션
        var selectedSortOption: SortOption = .popular
        @Pulse var selectedAnime: Int?
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadAnime:
            let topAnime = AnimeClient.shared.getTopAnime()
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setTopAnime($0) }
                .asObservable()
            
            let seasonAnime = AnimeClient.shared.getSeasonNow()
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setSeasonAnime($0) }
                .asObservable()
            
            let completeAnime = AnimeClient.shared.getCompleteAnime()
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setCompleteAnime($0) }
                .asObservable()
            
            let movieAnime = AnimeClient.shared.getMovieAnime()
                .map { $0.data.map { $0.toEntity() }.removeDuplicates() }
                .map { Mutation.setMovieAnime($0) }
                .asObservable()
             
            return Observable.concat(topAnime, seasonAnime, completeAnime, movieAnime)
            
        case .sortSelected(let sortOption):
            print("정렬 탭", sortOption.displayName)
            // topAnime 정렬 후 반환.
            let sortedTopAnime = currentState.topAnime.shuffled()
            return Observable.merge(
                Observable.just(Mutation.setSortOptions(sortOption)),
                Observable.just(Mutation.setTopAnime(sortedTopAnime))
            )

        case .animeSelected(let id):
            print("선택 됨", id)
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
        }
        return newState
    }
}
