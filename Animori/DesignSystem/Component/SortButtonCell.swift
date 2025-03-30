//
//  SortButtonCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit

final class SortButtonCell: BaseCollectionViewCell {
    
    static let identifier = "SortButtonCell"
    
    private let button = UIButton()
    private var config = UIButton.Configuration.filled()
    private var titleContainer = AttributeContainer()
    
    override var isSelected: Bool {
        didSet {
            configureButton()
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(button)
    }
    
    override func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .am(.base(.black))
        config.baseForegroundColor = .am(.base(.white))
        config.background.strokeColor = .am(.base(.white))
        config.background.strokeWidth = 0.6
        config.background.cornerRadius = 15
        button.configuration = config
        button.isUserInteractionEnabled = false
        titleContainer.font = .am(.subtitleMedium)
    }
    
    func configureData(title: String) {
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        configureButton()
    }
    
    private func configureButton() {
        config.baseBackgroundColor = isSelected ? .am(.base(.white)) : .am(.base(.black))
        config.baseForegroundColor = isSelected ? .am(.base(.black)) : .am(.base(.white))
        button.configuration = config
    }

}
