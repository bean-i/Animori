//
//  OTTCell.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import UIKit
import SnapKit

final class OTTCell: BaseCollectionViewCell {
    
    static let identifier = "OTTCell"
    
    private let containView = UIView()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override func configureHierarchy() {
        containView.addSubViews(titleLabel, iconImageView)
        contentView.addSubview(containView)
    }
    
    override func configureLayout() {
        containView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(7)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(2)
            make.verticalEdges.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(4)
        }
    }
    
    override func configureView() {
        containView.layer.cornerRadius = 5
        containView.backgroundColor = .am(.base(.gray))
        
        titleLabel.font = .am(.bodySemibold)
        titleLabel.textColor = .am(.base(.white))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        
        iconImageView.image = UIImage(systemName: "link")
        iconImageView.tintColor = .am(.base(.white))
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func configureData(title: String) {
        titleLabel.text = title
    }
    
}
