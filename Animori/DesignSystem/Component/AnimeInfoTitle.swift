//
//  AnimeInfoTitle.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit

final class AnimeInfoTitle: BaseView {
    
    private let titleLabel = UILabel()
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        titleLabel.text = title
        titleLabel.font = .am(.bodyMedium)
        titleLabel.textColor = .am(.base(.white))
        titleLabel.textAlignment = .left
    }
    
}
