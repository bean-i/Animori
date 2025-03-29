//
//  ExploreViewController.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit

struct SortingOption {
    let title: String
    let isSelected: Bool
}

final class ExploreViewController: BaseViewController<ExploreView> {
    private var sortingOptions: [SortingOption] = []
    private var featuredItems: [AnimeProtocol] = mockAnimeEntity
    private var contentSections: [[AnimeProtocol]] = [mockAnimeEntity.shuffled(), mockAnimeEntity.shuffled()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadData()
    }
    
    private func setupCollectionView() {
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }
    
    private func loadData() {
        // 샘플 데이터 (실제 데이터 소스로 교체 필요)
        sortingOptions = [
            SortingOption(title: "인기순", isSelected: true),
            SortingOption(title: "최신순", isSelected: false),
            SortingOption(title: "방영 중", isSelected: false),
            SortingOption(title: "방영 예정", isSelected: false)
        ]
        
        mainView.collectionView.reloadData()
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 + contentSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return sortingOptions.count
        } else if section == 1 {
            return 1 // FSPagerView용 단일 셀
        } else {
            return contentSections[section - 2].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortButtonCell.identifier, for: indexPath) as! SortButtonCell
            let option = sortingOptions[indexPath.item]
            cell.configureData(title: option.title)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendCollectionViewCell.identifier, for: indexPath) as! TrendCollectionViewCell
            cell.configure(with: featuredItems)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            let anime = contentSections[indexPath.section - 2][indexPath.item]
            cell.configureData(with: anime)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section >= 2 {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionHeaderView",
                for: indexPath
            ) as! SectionHeaderView
//            let section = contentSections[indexPath.section - 2]
            header.configure(with: "이번 시즌! 신작 애니메이션")
            return header
        }
        return UICollectionReusableView()
    }
}
