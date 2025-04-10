//
//  AnimeCharacterListView.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import UIKit
import SnapKit

final class AnimeCharacterListView: BaseView {
    
    let characterListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(characterListCollectionView)
    }
    
    override func configureLayout() {
        characterListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .am(.base(.black))

        characterListCollectionView.backgroundColor = .am(.base(.black))
        characterListCollectionView.showsVerticalScrollIndicator = false
        characterListCollectionView.showsHorizontalScrollIndicator = false
        characterListCollectionView.register(CharacterInfoCell.self, forCellWithReuseIdentifier: CharacterInfoCell.identifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterListCollectionView.collectionViewLayout = configureCharacterListCollectionViewLayout()
        layoutIfNeeded()
    }
    
    private func configureCharacterListCollectionViewLayout() -> UICollectionViewLayout {
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

