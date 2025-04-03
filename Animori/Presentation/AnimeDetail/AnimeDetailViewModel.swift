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
        case setDetail(any AnimeDetailProtocol)
        case setReviews([any AnimeReviewProtocol])
        case setCharacters([any AnimeCharacterProtocol])
        case setOTT([AnimeDetailOTT])
        case setSimilar([any AnimeRecommendProtocol])
        case setSections([AnimeDetailSection])
    }

    struct State {
        var animeDetail: (any AnimeDetailProtocol) = AnimeDetailEntity.empty
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var ott: [AnimeDetailOTT] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var sections: [AnimeDetailSection] = []
    }
    
    private let animeID: Int
    let initialState: State
    
    init(animeID: Int, initialState: State) {
        self.animeID = animeID
        self.initialState = initialState
    }
    
    // MARK: - mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadDetailInfo:
            // 애니메이션 상세 정보
            let animeDetail = Observable<Mutation>.deferred { [weak self] in
                guard let self else { return Observable.empty() }
                return AnimeDetailClient.shared.getAnimeFullById(id: animeID)
                    .map { Mutation.setDetail($0.data.toEntity()) }
                    .asObservable()
            }
            
            // 애니메이션 리뷰
            let animeReviews = Observable<Mutation>.deferred {  [weak self] in
                guard let self else { return Observable.empty() }
                return AnimeDetailClient.shared.getAnimeReviews(id: self.animeID)
                    .map { Mutation.setReviews($0.data.map { $0.toEntity() }) }
                    .asObservable()
            }
            
            // 애니메이션 캐릭터
            let animeCharacters = Observable<Mutation>.deferred { [weak self] in
                guard let self else { return Observable.empty() }
                return AnimeDetailClient.shared.getAnimeCharacters(id: self.animeID)
                    .map { Mutation.setCharacters($0.data.map { $0.toEntity() }) }
                    .asObservable()
            }
            
            // 애니메이션 추천
            let animeRecommend = Observable<Mutation>.deferred { [weak self] in
                guard let self else { return Observable.empty() }
                return AnimeDetailClient.shared.getAnimeRecommendations(id: self.animeID)
                    .delay(.seconds(1), scheduler: MainScheduler.instance)
                    .map { Mutation.setSimilar($0.data.map { $0.toEntity() }) }
                    .asObservable()
            }
            
            return Observable.concat([
                animeDetail,
                animeReviews,
                animeCharacters,
                animeRecommend
            ])
        }
    }
    
    // MARK: - reduce
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDetail(let detail):
            newState.animeDetail = detail
        case .setReviews(let reviews):
            newState.reviews = reviews
        case .setCharacters(let characters):
            newState.characters = characters
        case .setSimilar(let similar):
            newState.similarAnime = similar
        case .setSections(let sections):
            newState.sections = sections
        case .setOTT(let otts):
            newState.ott = otts
        }
        return newState
    }
}
