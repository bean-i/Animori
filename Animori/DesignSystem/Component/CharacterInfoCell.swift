//
//  CharacterInfoCell.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CharacterInfoCell: BaseCollectionViewCell {
    
    static let identifier = "CharacterInfoCell"
    
    private let characterImageView = UIImageView()
    private let lineView = UIView()
    private let nameLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubViews(
            characterImageView,
            lineView,
            nameLabel,
            subTitleLabel
        )
    }
    
    override func configureLayout() {
        characterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(nameLabel.snp.top).inset(-8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0.6)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(8)
            make.bottom.equalTo(subTitleLabel.snp.top).inset(-4)
            make.height.equalTo(12)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(8)
            make.height.equalTo(12)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.black))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = .am(.base(.white))
        contentView.clipsToBounds = true
        
        characterImageView.tintColor = .am(.base(.gray))
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        
        lineView.backgroundColor = .am(.base(.white))
        
        nameLabel.font = .am(.subtitleMedium)
        nameLabel.textColor = .am(.base(.white))
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .left
        
        subTitleLabel.font = .am(.captionLight)
        subTitleLabel.textColor = .am(.base(.white)).withAlphaComponent(0.8)
        subTitleLabel.numberOfLines = 1
        subTitleLabel.textAlignment = .left
    }
    
    func configureData(with character: any TopCharacterProtocol) {
        characterImageView.setImage(with: character.image)
        
        nameLabel.text = character.name
        subTitleLabel.text = character.favorites
    }
}
