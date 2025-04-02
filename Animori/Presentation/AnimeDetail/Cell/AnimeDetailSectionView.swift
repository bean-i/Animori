//
//  AnimeDetailSectionView.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import UIKit
import SnapKit

final class AnimeDetailSectionView: UICollectionReusableView {
    
    static let identifier = "AnimeDetailSectionView"
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        titleLabel.font = .am(.bodyMedium)
        titleLabel.textColor = .am(.base(.white))
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 1
    }

    func configure(with title: String) {
        titleLabel.text = title
    }

}
