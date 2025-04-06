//
//  GenreSearchCell.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import UIKit
import SnapKit

final class GenreSearchCell: BaseCollectionViewCell {
    
    static let identifier = "GenreSearchCell"
    private let genreLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(genreLabel)
    }
    
    override func configureLayout() {
        genreLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10))
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.black))
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = .am(.base(.white))
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        genreLabel.font = .am(.subtitleMedium)
        genreLabel.textColor = .am(.base(.white))
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 1
    }
    
    func configureData(with genre: any AnimeGenreProtocol) {
        genreLabel.text = genre.name
    }
}
