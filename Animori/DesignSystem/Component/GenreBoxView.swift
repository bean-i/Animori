//
//  GenreBoxView.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit

final class GenreBoxView: BaseView {
    
    private let contentView = UIView()
    private let genreLabel = UILabel()
    
    private let genre: String
    
    init(genre: String) {
        self.genre = genre
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(genreLabel)
        addSubview(contentView)
    }
    
    override func configureLayout() {
        contentView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .am(.base(.gray))
        contentView.layer.cornerRadius = 5
        
        genreLabel.text = genre
        genreLabel.textColor = .am(.base(.white))
        genreLabel.textAlignment = .center
        genreLabel.font = .am(.bodyRegular)
        genreLabel.numberOfLines = 1
        genreLabel.lineBreakMode = .byClipping
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = genreLabel.intrinsicContentSize
        return CGSize(width: labelSize.width + 8, height: 22)
    }
    
}
