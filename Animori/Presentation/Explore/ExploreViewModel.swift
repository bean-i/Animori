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
        case setShortAnime(([any AnimeProtocol]))
        case setSelectedAnime(Int)
    }
    
    struct State {
        var sort: [SortOption] = SortOption.allCases // 정렬 버튼
        @Pulse var topAnime: [any AnimeProtocol] // 탑인기 애니메이션
        @Pulse var seasonAnime: [any AnimeProtocol] // 이번 시즌 애니메이션
        @Pulse var completeAnime: [any AnimeProtocol] // 완결 명작 애니메이션
        @Pulse var shortAnime: [any AnimeProtocol] // 짧은 애니메이션
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
            // 추후 API 통신 적용
            print("로드")
            let topAnime = Observable.just(Mutation.setTopAnime(mockAnimeEntity.shuffled()))
            let seasonAnime = Observable.just(Mutation.setSeasonAnime(mockAnimeEntity.shuffled()))
            let completeAnime = Observable.just(Mutation.setCompleteAnime(mockAnimeEntity.shuffled()))
            let shortAnime = Observable.just(Mutation.setShortAnime(mockAnimeEntity.shuffled()))
            
            return Observable.merge(topAnime, seasonAnime, completeAnime, shortAnime)
            
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
        case .setShortAnime(let anime):
            newState.shortAnime = anime
        case .setSelectedAnime(let id):
            newState.selectedAnime = id
        }
        return newState
    }
}
