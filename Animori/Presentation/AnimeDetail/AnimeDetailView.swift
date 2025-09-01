//
//  AnimeDetailView.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit
import Floaty

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
    private let plotLabelView = TranslationView(reactor: TranslationViewModel())
    private let plotMoreButton = UIButton()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // 플로팅 버튼
    let floatyButton = Floaty()
    
    let finishedItem = FloatyItem()
    let watchingItem = FloatyItem()
    let plannedItem = FloatyItem()
    
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
            plotLabelView,
            plotInfoView,
            plotMoreButton,
            collectionView
        )
        scrollView.addSubview(scrollContainView)
        addSubViews(scrollView, floatyButton)
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
        
        plotLabelView.snp.makeConstraints { make in
            make.top.equalTo(plotInfoView.snp.top)
            make.leading.equalTo(plotInfoView.snp.trailing).offset(8)
            make.trailing.equalTo(plotMoreButton.snp.leading)
            make.height.greaterThanOrEqualTo(60)
        }
        
        plotMoreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(plotLabelView.snp.bottom)
            make.size.equalTo(24)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(plotLabelView.snp.bottom).offset(15)
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
        posterImageView.tintColor = .am(.base(.white))
        posterImageView.backgroundColor = .amGray
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
        
        configureFloatyButton()
    }
    
    private func configureFloatyButton() {
        // 메인 플로팅 버튼 설정
        floatyButton.buttonColor = .amGray
        floatyButton.plusColor = .amWhite
        floatyButton.paddingX = 20
        floatyButton.paddingY = 100
        
        // 시청 중 버튼 설정
        watchingItem.buttonColor = .amWhite
        watchingItem.title = LocalizedStrings.MyLibrary.watching
        watchingItem.tintColor = .amGray
        watchingItem.icon = UIImage(systemName: "play")
        floatyButton.addItem(item: watchingItem)
        
        // 시청 예정 버튼 설정
        plannedItem.buttonColor = .amWhite
        plannedItem.title = LocalizedStrings.MyLibrary.toWatch
        plannedItem.tintColor = .amGray
        plannedItem.icon = UIImage(systemName: "gauge.with.needle")
        floatyButton.addItem(item: plannedItem)
        
        // 시청 완료 버튼 설정
        finishedItem.buttonColor = .amWhite
        finishedItem.title = LocalizedStrings.MyLibrary.watched
        finishedItem.tintColor = .amGray
        finishedItem.icon = UIImage(systemName: "checkmark.square")
        floatyButton.addItem(item: finishedItem)
        
        // 아이템이 표시되는 방향 설정
        floatyButton.openAnimationType = .pop
        floatyButton.overlayColor = UIColor.black.withAlphaComponent(0.5)
        
        // 초기 위치 설정
        floatyButton.verticalDirection = .up
        floatyButton.relativeToSafeArea = true
        
        floatyButton.sticky = true
        floatyButton.hasShadow = true
    }
    
    // MARK: - ConfigureData
    func configureData(anime: any AnimeDetailProtocol) {
        
        posterImageView.setImage(from: anime.image)
        ratingLabel.text = "★ \(anime.rate)"
        configureGenre(genres: anime.genre)
        ageView.configureData(age: anime.age)
        periodLabel.text = anime.airedPeriod
        plotLabelView.setText(anime.plot)
    }
    
    func updateSaveStatusIcons(_ status: AnimeWatchStatus?) {
        let isCompleted = (status == .completed)
        let isWatching  = (status == .watching)
        let isPlanned   = (status == .planToWatch)

        finishedItem.icon = UIImage(
            systemName: isCompleted
            ? "checkmark.square.fill"
            : "checkmark.square"
        )
        watchingItem.icon = UIImage(
            systemName: isWatching
            ? "play.fill"
            : "play"
        )
        plannedItem.icon = UIImage(
            systemName: isPlanned
            ? "gauge.with.needle.fill"
            : "gauge.with.needle"
        )
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
        plotLabelView.toggleExpand()

        // 아이콘 토글
        let isExpandedNow = plotLabelView.isExpanded
        let iconName = isExpandedNow ? "chevron.up" : "chevron.down"
        plotMoreButton.setImage(UIImage(systemName: iconName), for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

}
