//
//  CharacterInfoRowView.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import UIKit
import SnapKit

final class CharacterInfoRowView: BaseView {

    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let separator = UIView()

    override func configureHierarchy() {
        stackView.addArrangedSubviews(titleLabel, valueLabel)
        addSubViews(
            stackView,
            separator
        )
    }

    override func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }

    override func configureView() {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        
        titleLabel.textColor = .am(.base(.white))
        titleLabel.font = .am(.subtitleMedium)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        valueLabel.textColor = .am(.base(.white))
        valueLabel.font = .am(.subtitleMedium)
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 1
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        separator.backgroundColor = .am(.base(.white)).withAlphaComponent(0.2)
    }
    
    func configure(title: String, value: String, isSeparator: Bool = false) {
        titleLabel.text = title
        valueLabel.text = value
        separator.isHidden = isSeparator
    }
}

