//
//  TrendCollectionViewCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit
import FSPagerView

final class TrendCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "TrendCollectionViewCell"
    
    private let trendPagerView = FSPagerView()
    
    override func configureHierarchy() {
        contentView.addSubview(trendPagerView)
    }
    
    override func configureLayout() {
        trendPagerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        let transformer = FSPagerViewTransformer(type: .overlap)
        transformer.minimumScale = 0.6
        transformer.minimumAlpha = 0.6
        trendPagerView.transformer = transformer
        
        trendPagerView.automaticSlidingInterval = 3.0
        trendPagerView.isInfinite = true
        
        trendPagerView.register(TrendPagerViewCell.self, forCellWithReuseIdentifier: TrendPagerViewCell.identifier)
    }
    
}

final class TrendPagerViewCell: FSPagerViewCell {
    
    static let identifier = "TrendPagerViewCell"
    
    private let posterImageView = UIImageView()
    private let url: String

    init(url: String) {
        self.url = url
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 이미지뷰 설정
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.image?.setImage(with: url)
    }
    
}
