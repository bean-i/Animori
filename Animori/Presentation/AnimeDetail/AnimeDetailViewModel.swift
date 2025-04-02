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
        case load
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
        var animeDetail: (any AnimeDetailProtocol)?
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var ott: [AnimeDetailOTT] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var sections: [AnimeDetailSection] = []
    }
    
    let initialState = State()
    
    // MARK: - mutate
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            // 실제 데이터 대신 목 데이터 사용 (필요에 따라 네트워크 호출 등으로 대체)
            let detail: any AnimeDetailProtocol = mockAnimeDetailEntity
            let reviews: [any AnimeReviewProtocol] = mockReviewEntity
            let characters: [any AnimeCharacterProtocol] = mockCharacterEntity
            let similar: [any AnimeRecommendProtocol] = mockRecommendEntities
            print("============")
            print(detail.OTT)
            // 각 섹션 모델 생성: 각 배열을 단일 아이템으로 변환
            let reviewSection = AnimeDetailSection(
                header: "리뷰",
                items: reviews.map { .review($0) }
            )
            let characterSection = AnimeDetailSection(
                header: "캐릭터",
                items: characters.map { .character($0) }
            )
            let ottSection = AnimeDetailSection(
                header: "OTT 바로가기",
                items: detail.OTT.map { .ott($0) }
            )
            let recommendSection = AnimeDetailSection(
                header: "비슷한 애니메이션 추천",
                items: similar.map { .recommend($0) }
            )
            let sections = [reviewSection, characterSection, ottSection, recommendSection]
            
            return .concat([
                .just(.setDetail(detail)),
                .just(.setReviews(reviews)),
                .just(.setCharacters(characters)),
                .just(.setOTT(detail.OTT)),
                .just(.setSimilar(similar)),
                .just(.setSections(sections))
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
