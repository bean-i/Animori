//
//  CharacterImageCell.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import UIKit
import SnapKit
import FSPagerView

final class CharacterImageCell: BaseFSPagerViewCell {
    
    static let identifier = "CharacterImageCell"

    private let posterImageView = UIImageView()
    private var currentTask: Task<Void, Never>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        currentTask?.cancel()
    }

    override func configureHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    override func configureView() {
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.tintColor = .am(.base(.gray))
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.backgroundColor = .amGray
    }
    
    
    func configureData(data: String) {
        currentTask?.cancel()
        currentTask = posterImageView.setImage(from: data)
    }
}
