//
//  AgeRatingView.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit

final class AgeRatingView: BaseView {
    
    private let contentView = UIView()
    private let ageLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(ageLabel)
        addSubview(contentView)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(3)
        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = 5
        ageLabel.font = .am(.bodyExtrabold)
        ageLabel.textColor = .am(.base(.white))
        ageLabel.textAlignment = .center
    }
    
    func configureData(age: String) {
        switch age {
        case AgeRatingView.Age.all.rawValue:
            ageLabel.text = AgeRatingView.Age.all.displayAge
            contentView.backgroundColor = .am(.age(.all))
            
        case AgeRatingView.Age.children.rawValue:
            ageLabel.text = AgeRatingView.Age.children.displayAge
            contentView.backgroundColor = .am(.age(.children))
            
        case AgeRatingView.Age.lowteen.rawValue:
            ageLabel.text = AgeRatingView.Age.lowteen.displayAge
            contentView.backgroundColor = .am(.age(.lowteen))
            
        case AgeRatingView.Age.highteen.rawValue:
            ageLabel.text = AgeRatingView.Age.highteen.displayAge
            contentView.backgroundColor = .am(.age(.highteen))
            
        case AgeRatingView.Age.restricted.rawValue:
            ageLabel.text = AgeRatingView.Age.restricted.displayAge
            contentView.backgroundColor = .am(.age(.restricted))
            
        case AgeRatingView.Age.adult.rawValue:
            ageLabel.text = AgeRatingView.Age.adult.displayAge
            contentView.backgroundColor = .am(.age(.adult))
            
        default: return
        }
    }
}

extension AgeRatingView {
    enum Age: String {
        case all = "G - All Ages"
        case children = "PG - Children"
        case lowteen = "PG-13 - Teens 13 or older"
        case highteen = "R - 17+ (violence & profanity)"
        case restricted = "R+ - Mild Nudity"
        case adult = "Rx - Hentai"
        
        var displayAge: String {
            switch self {
            case .all: return "ALL"
            case .children: return "+7"
            case .lowteen: return "+13"
            case .highteen: return "+17"
            case .restricted: return "+18"
            case .adult: return "+19"
            }
        }
    }
}
