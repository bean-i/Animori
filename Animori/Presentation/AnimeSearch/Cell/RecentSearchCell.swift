//
//  RecentSearchCell.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import SnapKit

final class RecentSearchCell: BaseCollectionViewCell {
    
    static let identifier = "RecentSearchCell"
    
    private let titleLabel = UILabel()
    private let removeButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubViews(titleLabel, removeButton)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(3)
            make.trailing.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.size.equalTo(10)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.gray))
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        titleLabel.textColor = .am(.base(.white))
        titleLabel.font = .am(.bodyMedium)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.tintColor = .am(.base(.white)).withAlphaComponent(0.8)
        removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
    
    func configureData(with text: String) {
        titleLabel.text = text
    }
    
    @objc private func didTapRemoveButton() {
        print("Remove button tapped: \(titleLabel.text ?? "")")
    }
}
