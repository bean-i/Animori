//
//  AnimeListView.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import SnapKit

final class AnimeListView: BaseView {
    
    let sortButtonCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let animeListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        addSubViews(sortButtonCollectionView, animeListCollectionView)
    }
    
    override func configureLayout() {
        sortButtonCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(35)
        }
        
        animeListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .am(.base(.black))
        
        sortButtonCollectionView.backgroundColor = .am(.base(.black))
        sortButtonCollectionView.showsVerticalScrollIndicator = false
        sortButtonCollectionView.showsHorizontalScrollIndicator = false
        sortButtonCollectionView.register(SortButtonCell.self, forCellWithReuseIdentifier: SortButtonCell.identifier)
        
        animeListCollectionView.backgroundColor = .am(.base(.black))
        animeListCollectionView.showsVerticalScrollIndicator = false
        animeListCollectionView.showsHorizontalScrollIndicator = false
        animeListCollectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sortButtonCollectionView.collectionViewLayout = configureSortCollectionViewLayout()
        animeListCollectionView.collectionViewLayout = configureAnimeListCollectionViewLayout()
        layoutIfNeeded()
    }
    
    private func configureSortCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = CGSize(width: 50, height: 35)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return layout
    }
    
    private func configureAnimeListCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        let spacing: CGFloat = 8
        let totalWidth = frame.width
        let itemWidth = (totalWidth - (2 * inset) - (2 * spacing)) / 3
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = inset
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.6)
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: inset, right: inset)
        return layout
    }
    
}
