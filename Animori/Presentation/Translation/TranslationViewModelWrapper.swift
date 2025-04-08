//
//  TranslationViewModelWrapper.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import Foundation
import RxSwift

final class TranslationViewModelWrapper: ObservableObject {
    let reactor: TranslationViewModel

    @Published var sourceText: String?
    @Published var translatedText: String?

    private var disposeBag = DisposeBag()

    init(reactor: TranslationViewModel) {
        self.reactor = reactor

        // sourceText 업데이트
        reactor.state
            .map { $0.sourceText }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                self?.sourceText = value
            })
            .disposed(by: disposeBag)

        // translatedText 업데이트
        reactor.state
            .map { $0.translatedText }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                self?.translatedText = value
            })
            .disposed(by: disposeBag)
    }
}
