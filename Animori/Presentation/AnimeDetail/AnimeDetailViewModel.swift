//
//  AnimeDetailViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation
import ReactorKit
import RxSwift
import RxDataSources

final class AnimeDetailViewModel: Reactor {

    enum Action {
        case loadDetailInfo
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDetail(any AnimeDetailProtocol)
        case setReviews([any AnimeReviewProtocol])
        case setCharacters([any AnimeCharacterProtocol])
        case setSimilar([any AnimeRecommendProtocol])
        // 필요한 경우 setSections, setOTT 등을 추가할 수 있음
    }

    struct State {
        var animeDetail: (any AnimeDetailProtocol) = AnimeDetailEntity.empty
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var isLoading: Bool = false
    }
    
    private let animeID: Int
    let initialState: State
    
    init(animeID: Int, initialState: State) {
        self.animeID = animeID
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadDetailInfo:
            let startLoading = Observable.just(Mutation.setLoading(true))
            
            let detailObs: Single<Mutation> = AnimeDetailClient.shared.getAnimeFullById(id: animeID)
                .map { Mutation.setDetail($0.data.toEntity()) }
            let reviewsObs: Single<Mutation> = AnimeDetailClient.shared.getAnimeReviews(id: animeID)
                .map { Mutation.setReviews($0.data.map { $0.toEntity() }) }
            let charactersObs: Single<Mutation> = AnimeDetailClient.shared.getAnimeCharacters(id: animeID)
                .map { Mutation.setCharacters($0.data.map { $0.toEntity() }) }
            let recommendObs: Single<Mutation> = AnimeDetailClient.shared.getAnimeRecommendations(id: animeID)
                .delay(.seconds(1), scheduler: MainScheduler.instance)
                .map { Mutation.setSimilar($0.data.map { $0.toEntity() }) }
            
            let allData = Single.zip(detailObs, reviewsObs, charactersObs, recommendObs) { detail, reviews, characters, similar -> [Mutation] in
                return [detail, reviews, characters, similar]
            }

            let finishLoading = Observable.just(Mutation.setLoading(false))
            
            // startLoading 후 모든 데이터를 순차적으로 방출하고, 마지막에 로딩 false를 방출합니다.
            return Observable.concat([
                startLoading,
                allData.asObservable().flatMap { Observable.from($0) },
                finishLoading
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let loading):
            newState.isLoading = loading
        case .setDetail(let detail):
            newState.animeDetail = detail
        case .setReviews(let reviews):
            newState.reviews = reviews
        case .setCharacters(let characters):
            newState.characters = characters
        case .setSimilar(let similar):
            newState.similarAnime = similar
        }
        return newState
    }
}
