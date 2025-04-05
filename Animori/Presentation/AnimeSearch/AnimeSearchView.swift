//
//  AnimeSearchView.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import SnapKit

final class AnimeSearchView: BaseView {
    
    let searchBar = UISearchBar()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let tapGesture = UITapGestureRecognizer()
    
    override func configureHierarchy() {
        addSubViews(searchBar, collectionView)
    }
    
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
        
        backgroundColor = .am(.base(.black))
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.layer.borderColor = .am(.base(.white))
        searchBar.searchTextField.layer.borderWidth = 0.6
        searchBar.searchTextField.backgroundColor = .am(.base(.black))
        searchBar.searchTextField.leftView?.tintColor = .am(.base(.white))
        searchBar.searchTextField.textColor = .am(.base(.white))
        searchBar.searchTextField.font = .am(.subtitleMedium)
        searchBar.searchTextField.textColor = .am(.base(.white))
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "애니메이션을 검색해 보세요.",
            attributes: [
                .foregroundColor: UIColor.am(.base(.white)).withAlphaComponent(0.7),
                .font: UIFont.am(.subtitleMedium)
            ]
        )
        
        collectionView.backgroundColor = .am(.base(.black))
        collectionView.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
        collectionView.register(GenreSearchCell.self, forCellWithReuseIdentifier: GenreSearchCell.identifier)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.register(CharacterInfoCell.self, forCellWithReuseIdentifier: CharacterInfoCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            if sectionIndex == 0 {
                return self?.configureRecentSearchLayout()
            } else if sectionIndex == 1 {
                return self?.configureGenreSearchLayout()
            } else if sectionIndex == 2 {
                return self?.configureTopAnimeLayout()
            } else {
                return self?.configureTopCharacterLayout()
            }
        }
    }
    
    // 최근 검색어 섹션
    private func configureRecentSearchLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(28)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(28)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
        
        return section
    }
    
    // 장르 검색 섹션
    private func configureGenreSearchLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(36)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(36)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
        
        return section
    }
    
    // Top 애니메이션 섹션
    private func configureTopAnimeLayout() -> NSCollectionLayoutSection {
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
            heightDimension: .estimated(22)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
        return section
    }
    
    // Top 캐릭터 섹션
    private func configureTopCharacterLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(130),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
        
        return section
    }
    
}
