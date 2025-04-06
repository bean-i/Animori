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
    
    private var id: String = ""
    private var keyword: String = ""
    
    var onRemoveTapped: ((String, String) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubViews(titleLabel, removeButton)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.gray))
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

        titleLabel.textColor = .am(.base(.white))
        titleLabel.font = .am(.titleMedium)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1

        removeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        removeButton.tintColor = .am(.base(.white)).withAlphaComponent(0.8)
        removeButton.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
    }
    
    func configureData(with id: String, keyword: String) {
        self.id = id
        self.keyword = keyword
        titleLabel.text = keyword
    }
    
    @objc private func didTapRemoveButton() {
        onRemoveTapped?(id, keyword)
    }
    
}
