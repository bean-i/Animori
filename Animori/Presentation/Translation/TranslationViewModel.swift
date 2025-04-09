//
//  TranslationViewModel.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import Foundation
import ReactorKit

final class TranslationViewModel: Reactor {
    enum Action {
        case setText(String)
    }

    enum Mutation {
        case setSourceText(String)
        case setTranslatedText(String)
    }

    struct State {
        var sourceText: String?
        var translatedText: String?
    }

    let initialState = State()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setText(text):
            return .just(.setSourceText(text))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSourceText(text): newState.sourceText = text
        case let .setTranslatedText(text): newState.translatedText = text
        }
        return newState
    }

    func setTranslatedText(_ text: String) {
        self.action.onNext(.setText(text))
    }
}
