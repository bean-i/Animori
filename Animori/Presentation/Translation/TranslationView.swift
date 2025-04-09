//
//  TranslationView.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import UIKit
import SwiftUI
import SnapKit

final class TranslationView: UIView {
    private let reactor: TranslationViewModel
    private let reactorWrapper: TranslationViewModelWrapper
    
    var isExpanded: Bool = false {
        didSet {
            updateView()
        }
    }

    private var hostingController: UIHostingController<AnyView>?

    init(reactor: TranslationViewModel) {
        self.reactor = reactor
        self.reactorWrapper = TranslationViewModelWrapper(reactor: reactor)
        super.init(frame: .zero)
        updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setText(_ text: String) {
        reactor.action.onNext(.setText(text))
    }

    func toggleExpand() {
        isExpanded.toggle()
    }

    private func updateView() {
        hostingController?.view.removeFromSuperview()

        let swiftUIView = TranslationComponentView(
            reactorWrapper: reactorWrapper,
            isExpanded: Binding(
                get: { self.isExpanded },
                set: { self.isExpanded = $0 }
            )
        )

        let host = UIHostingController(rootView: AnyView(swiftUIView))
        host.view.backgroundColor = .clear

        hostingController = host
        addSubview(host.view)
        host.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
