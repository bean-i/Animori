//
//  AnimeInfoBoxView.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit
import SnapKit

final class AnimeInfoBoxView: BaseView {
    
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let detailView = UIView()
    
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }
    
    override func configureHierarchy() {
        contentStackView.addArrangedSubviews(titleLabel, detailView)
        addSubview(contentStackView)
    }
    
    override func configureLayout() {
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
//        titleLabel.snp.makeConstraints { make in
//            make.leading.centerY.equalToSuperview()
//        }
//        
//        detailView.snp.makeConstraints { make in
//            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
//            make.centerY.equalToSuperview()
//        }
    }
    
    override func configureView() {
        contentStackView.backgroundColor = .red
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        
        titleLabel.text = "\(title) |"
        titleLabel.font = .am(.bodyMedium)
        titleLabel.textColor = .am(.base(.white))
        titleLabel.textAlignment = .left
        
        detailView.backgroundColor = .blue
    }
    
    func configureCustomView(_ view: UIView) {
        detailView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
}
