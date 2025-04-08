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
        case setError(Error)
    }

    struct State {
        var animeDetail: (any AnimeDetailProtocol) = AnimeDetailEntity.empty
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var isLoading: Bool = false
        var ottURL: URL? = nil
        @Pulse var error: Error? = nil
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
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()

            let reviewsObs = AnimeDetailClient.shared.getAnimeReviews(id: animeID)
                .map { Mutation.setReviews($0.data.map { $0.toEntity() }) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()

            let charactersObs = AnimeDetailClient.shared.getAnimeCharacters(id: animeID)
                .map { Mutation.setCharacters($0.data.map { $0.toEntity() }) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()

            let recommendObs = AnimeDetailClient.shared.getAnimeRecommendations(id: animeID)
                .map { Mutation.setSimilar($0.data.map { $0.toEntity() }) }
                .catch { error in
                    Single.just(Mutation.setError(error))
                }
                .asObservable()

            let networkRequests = Observable.merge(detailObs, reviewsObs, charactersObs, recommendObs)
            
            let finishLoading = Observable.just(Mutation.setLoading(false))

            return Observable.concat([
                startLoading,
                networkRequests,
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
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}
