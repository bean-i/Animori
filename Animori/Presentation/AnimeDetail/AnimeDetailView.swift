//
//  AnimeDetailView.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit

final class AnimeDetailView: BaseView {
    let scrollView = UIScrollView()
    let scrollContainView = UIView()
    
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let gradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let genreStackView = UIStackView()
    private let ratingLabel = UILabel()
    
    private let ageInfoView = AnimeInfoTitle(title: "\(LocalizedStrings.AnimeDetail.rating) |")
    private let ageView = AgeRatingView()
    
    private let periodInfoView = AnimeInfoTitle(title: "\(LocalizedStrings.AnimeDetail.aired) |")
    private let periodLabel = UILabel()
    
    private let plotInfoView = AnimeInfoTitle(title: "\(LocalizedStrings.AnimeDetail.synopsis) |")
    private let plotLabel = UILabel()
    private let plotMoreButton = UIButton()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var collectionViewHeightConstraint: Constraint?
    private var lastCollectionViewHeight: CGFloat = 0
    
    override func configureHierarchy() {
        contentView.addSubViews(posterImageView, gradientView)
        scrollContainView.addSubViews(
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
        scrollView.addSubview(scrollContainView)
        addSubview(scrollView)
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        scrollContainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-15)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalTo(posterImageView.snp.bottom)
        }
        
        genreStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualTo(ratingLabel.snp.trailing)
            make.height.equalTo(22)
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
            make.width.equalTo(40)
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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            collectionViewHeightConstraint = make.height.equalTo(300).constraint
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
        
        let newHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        if lastCollectionViewHeight != newHeight {
            lastCollectionViewHeight = newHeight
            collectionViewHeightConstraint?.update(offset: newHeight)
            layoutIfNeeded()
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
        
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .am(.base(.black))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        collectionView.register(OTTCell.self, forCellWithReuseIdentifier: OTTCell.identifier)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.register(AnimeDetailSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AnimeDetailSectionView.identifier)
    }
    
    // MARK: - ConfigureData
    func configureData(anime: any AnimeDetailProtocol) {
        
        posterImageView.setImage(from: anime.image)
        ratingLabel.text = "★ \(anime.rate)"
        configureGenre(genres: anime.genre)
        ageView.configureData(age: anime.age)
        periodLabel.text = anime.airedPeriod
        plotLabel.text = anime.plot
    }
    
    // MARK: - Compositional Layout
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sectionIndex {
            case 0: return self?.configureReviewSectionLayout()
            case 1: return self?.configureCharacterSectionLayout()
            case 2: return self?.configureOTTSectionLayout()
            case 3: return self?.configureRecommendLayout()
            default: return nil
            }
        }
    }

    // 리뷰 섹션
    private func configureReviewSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20)
        return section
    }

    // 캐릭터 섹션
    private func configureCharacterSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                              heightDimension: .absolute(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                               heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 15
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        return section
    }

    // OTT 바로가기 섹션
    private func configureOTTSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(28)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 2. 그룹 크기 및 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(28)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 20,
            trailing: 20
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }

    // 추천 섹션
    private func configureRecommendLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(220)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(220)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(20)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    // MARK: - 장르 나타내기
    private func configureGenre(genres: [String]) {
        let availableWidth: CGFloat = 200
        var currentWidth: CGFloat = 0
        
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for tag in genres {
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
    
    // MARK: - 줄거리 더보기
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
