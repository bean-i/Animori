//
//  CharacterCell.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import UIKit
import SnapKit

final class CharacterCell: BaseCollectionViewCell {
    
    static let identifier = "CharacterCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    
    private var currentTask: Task<Void, Never>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        currentTask?.cancel()
    }
    
    override func configureHierarchy() {
        contentView.addSubViews(imageView, nameLabel)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .am(.base(.gray))
        imageView.backgroundColor = .am(.base(.gray))
        
        nameLabel.font = .am(.bodyMedium)
        nameLabel.textColor = .am(.base(.white))
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
    }
    
    func configureData(_ character: any AnimeCharacterProtocol) {
        
        currentTask?.cancel()
        currentTask = imageView.setImage(from: character.image)
        
        nameLabel.text = character.name
    }
    
}
