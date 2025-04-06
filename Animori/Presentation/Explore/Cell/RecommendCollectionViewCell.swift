//
//  RecommendCollectionViewCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit

final class RecommendCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "RecommendCollectionViewCell"
    
    private let shadowContainerView = UIView()
    private let containView = UIView()
    private let posterImageView = UIImageView()
    private let gradientView = UIView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    
    private let gradientLayer = CAGradientLayer()
    
    private var currentTask: Task<Void, Never>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        currentTask?.cancel()
    }
    
    override func configureHierarchy() {
        containView.addSubViews(
            posterImageView,
            gradientView,
            ratingLabel
        )
        
        shadowContainerView.addSubview(containView)
        
        contentView.addSubViews(
            shadowContainerView,
            titleLabel
        )
    }
    
    override func configureLayout() {
        shadowContainerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-5)
        }
        
        containView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(12)
        }
    }
    
    override func configureView() {
        shadowContainerView.clipsToBounds = false
        
        containView.clipsToBounds = true
        containView.layer.cornerRadius = 10
        containView.layer.borderWidth = 0.6
        containView.layer.borderColor = .am(.base(.white))
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.tintColor = .am(.base(.gray))
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        titleLabel.font = .am(.bodySemibold)
        titleLabel.textColor = .am(.base(.white))
        
        ratingLabel.font = .am(.bodyRegular)
        ratingLabel.textColor = .am(.base(.white))
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func configureData(with anime: any AnimeProtocol) {
        currentTask?.cancel()
        currentTask = posterImageView.setImage(from: anime.image)

        titleLabel.text = anime.title
        ratingLabel.text = "★ \(anime.rate)"
    }
    
    func configureRecommendData(with anime: any AnimeRecommendProtocol) {
        currentTask?.cancel()
        currentTask = posterImageView.setImage(from: anime.image)
        
        titleLabel.text = anime.title
    }
    
}
