//
//  AnimeDetailView.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit

final class AnimeDetailView: BaseView {
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let genreStackView = UIStackView()
    private let ratingLabel = UILabel()
    
    private let ageInfoView = AnimeInfoTitle(title: "이용가 |")
    private let ageView = AgeRatingView()
    
    private let periodInfoView = AnimeInfoTitle(title: "방영기간 |")
    private let periodLabel = UILabel()
    
    private let plotInfoView = AnimeInfoTitle(title: "줄거리 |")
    private let plotLabel = UILabel()
    private let plotMoreButton = UIButton()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        contentView.addSubViews(posterImageView, gradientView)
        addSubViews(
            contentView,
            genreStackView,
            ratingLabel,
            ageInfoView,
            ageView,
            periodInfoView,
            periodLabel,
            plotInfoView,
            plotLabel,
            plotMoreButton,
            collectionView
        )
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        genreStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualTo(ratingLabel.snp.trailing)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().inset(20)
        }
        
        ageInfoView.snp.makeConstraints { make in
            make.top.equalTo(genreStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        ageView.snp.makeConstraints { make in
            make.leading.equalTo(ageInfoView.snp.trailing).offset(8)
            make.centerY.equalTo(ageInfoView.snp.centerY)
        }
        
        periodInfoView.snp.makeConstraints { make in
            make.top.equalTo(ageInfoView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.leading.equalTo(periodInfoView.snp.trailing).offset(8)
            make.centerY.equalTo(periodInfoView.snp.centerY)
        }
        
        plotInfoView.snp.makeConstraints { make in
            make.top.equalTo(periodInfoView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
        
        plotLabel.snp.makeConstraints { make in
            make.top.equalTo(plotInfoView.snp.top)
            make.leading.equalTo(plotInfoView.snp.trailing).offset(8)
            make.trailing.equalTo(plotMoreButton.snp.leading)
        }
        
        plotMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(plotLabel.snp.bottom)
            make.size.equalTo(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(plotLabel.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        backgroundColor = .am(.base(.black))
        
        contentView.clipsToBounds = true
        posterImageView.tintColor = .am(.base(.gray))
        posterImageView.backgroundColor = .white
        posterImageView.contentMode = .scaleAspectFill
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.amBlack.cgColor
        ]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
        
        genreStackView.axis = .horizontal
        genreStackView.spacing = 5
        genreStackView.distribution = .fillProportionally
        genreStackView.alignment = .leading
        genreStackView.isLayoutMarginsRelativeArrangement = true
        genreStackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        genreStackView.clipsToBounds = true
        
        ratingLabel.font = .am(.titleSemibold)
        ratingLabel.textColor = .am(.base(.white))
        
        periodLabel.font = .am(.captionLight)
        periodLabel.textColor = .am(.base(.white))
        periodLabel.textAlignment = .left
        
        plotLabel.font = .am(.bodyRegular)
        plotLabel.textColor = .am(.base(.white))
        plotLabel.textAlignment = .left
        plotLabel.numberOfLines = 4
        
        plotMoreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        plotMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        plotMoreButton.tintColor = .am(.base(.white))
    }
    
    func configureData(anime: any AnimeProtocol) {
        posterImageView.setImage(with: "https://img.youtube.com/vi/ZEkwCGJ3o7M/hqdefault.jpg")
        ratingLabel.text = "★ \(anime.rate)"
        configureGenre(genres: anime.genre)
        ageView.configureData(age: AgeRatingView.Age.children)
        periodLabel.text = "2022.04.09 ~ 2022.06.25"
        plotLabel.text = "Corrupt politicians, frenzied nationalists, and other warmongering forces constantly jeopardize the thin veneer of peace between neighboring countries Ostania and Westalis. In spite of their plots, renowned spy and Corrupt politicians, frenzied nationalists, and other warmongering forces constantly jeopardize the thin veneer of peace between neighboring countries Ostania and Westalis. In spite of their plots, renowned spy and...!!!!!"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    private func configureGenre(genres: [String]) {
        print(#function)
        let availableWidth: CGFloat = 200
        var currentWidth: CGFloat = 0
        
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for tag in genres {
            print(tag)
            let genreBox = GenreBoxView(genre: tag)
            genreBox.layoutIfNeeded()
            let boxWidth = genreBox.intrinsicContentSize.width
            let nextWidth = currentWidth + boxWidth + (currentWidth > 0 ? genreStackView.spacing : 0)
            if nextWidth <= availableWidth {
                genreStackView.addArrangedSubview(genreBox)
                currentWidth = nextWidth
            } else {
                break
            }
        }
    }
    
    @objc private func moreButtonTapped() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if self?.plotLabel.numberOfLines == 0 {
                self?.plotMoreButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                self?.plotLabel.numberOfLines = 4
            } else {
                self?.plotMoreButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                self?.plotLabel.numberOfLines = 0
            }
            self?.layoutIfNeeded()
        }
    }
}
