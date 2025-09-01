//
//  StorageViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/12/25.
//

import Foundation
import ReactorKit

final class StorageViewModel: Reactor {
    
    enum Action {
        case loadStorage
    }
    
    enum Mutation {
        case setSections([StorageSection])
        case setError(Error)
    }
    
    struct State {
        var sections: [StorageSection] = []
        var error: Error?
    }
    
    let initialState: State
    private let repository: AnimeSaveStatusService
    
    init(initialState: State,
         repository: AnimeSaveStatusService = AnimeSaveStatusRepository()) {
        self.initialState = initialState
        self.repository = repository
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadStorage:
            // Realm 에서 불러오기
            return Observable.create { [weak self] obs in
                guard let self = self else {
                    obs.onCompleted()
                    return Disposables.create()
                }
                let watching = self.repository.fetchByStatus(status: .watching)
                let planned  = self.repository.fetchByStatus(status: .planToWatch)
                let finished = self.repository.fetchByStatus(status: .completed)
                
                let sections: [StorageSection] = [
                  StorageSection(
                    header: LocalizedStrings.MyLibrary.watching,
                    items: watching.map { .watching($0) }
                  ),
                  StorageSection(
                    header: LocalizedStrings.MyLibrary.toWatch,
                    items: planned.map { .planned($0) }
                  ),
                  StorageSection(
                    header: LocalizedStrings.MyLibrary.watched,
                    items: finished.map { .finished($0) }
                  )
                ]
                
                obs.onNext(.setSections(sections))
                obs.onCompleted()
                return Disposables.create()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSections(let sections):
            newState.sections = sections
            newState.error = nil
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}
