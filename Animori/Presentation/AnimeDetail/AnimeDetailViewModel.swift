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
        case saveButtonTapped(AnimeWatchStatus)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDetail(any AnimeDetailProtocol)
        case setReviews([any AnimeReviewProtocol])
        case setCharacters([any AnimeCharacterProtocol])
        case setSimilar([any AnimeRecommendProtocol])
        case setOTTURL(URL?)
        case setError(Error)
        case setSaveStatus(AnimeWatchStatus?)
        case setSaveResult(Bool)
    }

    struct State {
        var animeDetail: (any AnimeDetailProtocol) = AnimeDetailEntity.empty
        var reviews: [any AnimeReviewProtocol] = []
        var characters: [any AnimeCharacterProtocol] = []
        var similarAnime: [any AnimeRecommendProtocol] = []
        var isLoading: Bool = false
        var ottURL: URL? = nil
        @Pulse var error: Error? = nil
        @Pulse var savedStatus: AnimeWatchStatus? = nil
        @Pulse var saveResult: Bool? = nil
    }
    
    let animeID: Int
    let initialState: State
    private let saveService = AnimeSaveStatusRepository()
    
    init(animeID: Int, initialState: State) {
        self.animeID = animeID
        self.initialState = initialState
        print(saveService.getFileURL(), "FILEURL")
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
            
            let statusObs = Observable.just(Mutation.setSaveStatus(saveService.getAnimeStatus(animeId: animeID)))
            
            let finishLoading = Observable.just(Mutation.setLoading(false))
            
            return Observable.concat([
                startLoading,
                networkRequests,
                statusObs,
                finishLoading
            ])
            
        case .ottTapped(let url):
            let moveTo = URL(string: url)
            return Observable.just(Mutation.setOTTURL(moveTo))
            
        case .saveButtonTapped(let newStatus):
            return Observable.create { [weak self] obs in
                guard let self = self else {
                    obs.onCompleted()
                    return Disposables.create()
                }
                // 토글: 저장됐으면 true, 삭제됐으면 false
                let didSave = self.saveService.toggleStatus(
                    anime: self.currentState.animeDetail,
                    status: newStatus
                )
                // 1) 저장 상태(AnimeWatchStatus?) 업데이트
                obs.onNext(.setSaveStatus(self.saveService.getAnimeStatus(animeId: self.animeID)))
                // 2) 토글 결과(Bool) 업데이트
                obs.onNext(.setSaveResult(didSave))
                obs.onCompleted()
                return Disposables.create()
            }
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
        case .setSaveStatus(let status):
            newState.savedStatus = status
        case .setSaveResult(let result):
            newState.saveResult = result
        }
        return newState
    }
}
