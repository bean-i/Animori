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
        case ottTapped(String)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDetail(any AnimeDetailProtocol)
        case setReviews([any AnimeReviewProtocol])
        case setCharacters([any AnimeCharacterProtocol])
        case setSimilar([any AnimeRecommendProtocol])
        case setOTTURL(URL?)
    }

    struct State {
        var animeDetail: (any AnimeDetailProtocol) = AnimeDetailEntity.empty
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var isLoading: Bool = false
        var ottURL: URL? = nil
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
            
            let detailObs = AnimeDetailClient.shared.getAnimeFullById(id: animeID)
                .map { Mutation.setDetail($0.data.toEntity()) }
                .asObservable()
            
            let reviewsObs = detailObs.flatMap { [weak self] _ in
                guard let self else { return Observable.just(Mutation.setReviews([]))}
                return AnimeDetailClient.shared.getAnimeReviews(id: animeID)
                    .map { Mutation.setReviews($0.data.map { $0.toEntity() }) }
                    .asObservable()
            }
            
            let charactersObs = AnimeDetailClient.shared.getAnimeCharacters(id: animeID)
                .map { Mutation.setCharacters($0.data.map { $0.toEntity() }) }
                .asObservable()
            
            let recommendObs = charactersObs.flatMap { [weak self] _ in
                guard let self else { return Observable.just(Mutation.setSimilar([]))}
                return AnimeDetailClient.shared.getAnimeRecommendations(id: self.animeID)
                    .map { Mutation.setSimilar($0.data.map { $0.toEntity() }) }
                    .asObservable()
            }
            
            let finishLoading = recommendObs.map { _ in Mutation.setLoading(false) }
            
            return Observable.concat([
                startLoading,
                detailObs,
                reviewsObs,
                charactersObs,
                recommendObs,
                finishLoading
            ])
        case .ottTapped(let url):
            let moveTo = URL(string: url)
            return Observable.just(Mutation.setOTTURL(moveTo))
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
        case .setOTTURL(let url):
            newState.ottURL = url
        }
        return newState
    }
}
