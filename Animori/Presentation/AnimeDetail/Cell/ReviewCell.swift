//
//  ReviewCell.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import UIKit
import SnapKit

final class ReviewCell: BaseCollectionViewCell {
    
    static let identifier = "ReviewCell"
    
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let ratingView = UIView()
    private let starIcon = UIImageView()
    private let ratingLabel = UILabel()
    private let reviewLabel = UILabel()
    
    override func configureHierarchy() {
        ratingView.addSubViews(
            starIcon,
            ratingLabel
        )
        
        contentView.addSubViews(
            profileImageView,
            usernameLabel,
            ratingView,
            reviewLabel
        )
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(30)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
        }

        ratingView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(profileImageView)
        }
        
        starIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.verticalEdges.equalToSuperview().inset(3)
            make.width.height.equalTo(15)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starIcon.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(starIcon)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.black))
        contentView.layer.cornerRadius = 15
        contentView.layer.borderColor = .am(.base(.white))
        contentView.layer.borderWidth = 0.6
        
        profileImageView.backgroundColor = .gray
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        
        usernameLabel.font = .am(.bodyMedium)
        usernameLabel.textColor = .am(.base(.white))
        
        ratingView.layer.cornerRadius = 10
        ratingView.backgroundColor = .am(.base(.white))
        
        starIcon.image = UIImage(systemName: "star.fill")
        starIcon.tintColor = .am(.base(.black))
        starIcon.contentMode = .scaleAspectFit
        
        ratingLabel.font = .am(.bodyRegular)
        ratingLabel.textColor = .am(.base(.black))
        
        reviewLabel.font = .am(.bodyMedium)
        reviewLabel.textColor = .am(.base(.white))
        reviewLabel.numberOfLines = 0
        reviewLabel.lineBreakMode = .byTruncatingTail
    }
    
    func configureData(username: String, rating: Int, review: String) {
        usernameLabel.text = username
        ratingLabel.text = "\(rating)"
        reviewLabel.text = review
    }
}
