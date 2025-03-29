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
    private var config = UIButton.Configuration.plain()
    private var titleContainer = AttributeContainer()
    
    override var isSelected: Bool {
        didSet {
            button.isSelected = isSelected
            print("선택됨")
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
        
        titleContainer.font = .am(.subtitleMedium)
        
        button.configurationUpdateHandler = { [weak self] btn in
            switch btn.state {
            case .selected:
                self?.config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.foregroundColor = .am(.base(.black)) // 눌렸을 때 흰색
                    return outgoing
                }
                self?.config.baseBackgroundColor = .am(.base(.white))
                self?.config.background.strokeColor = .am(.base(.black))
            default:
                self?.config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.foregroundColor = .am(.base(.white)) // 눌렸을 때 흰색
                    return outgoing
                }
                self?.config.baseBackgroundColor = .am(.base(.black))
                self?.config.background.strokeColor = .am(.base(.white))
            }
        }
    }
    
    func configureData(title: String) {
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        button.configuration = config
    }

}
