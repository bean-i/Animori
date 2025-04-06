//
//  SectionHeaderView.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit

// MARK: - 화면 전환 프로토콜
protocol SectionHeaderViewDelegate: AnyObject {
    func sectionHeaderViewTapped(_ headerView: SectionHeaderView)
}

// MARK: - SectionHeaderView
final class SectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SectionHeaderView"
    weak var delegate: SectionHeaderViewDelegate?
    
    private let titleLabel = UILabel()
    private let arrowButton = UIButton()
    
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
        addSubViews(titleLabel, arrowButton)
    }
    
    func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        arrowButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureView() {
        titleLabel.font = .am(.titleSemibold)
        titleLabel.textColor = .am(.base(.white))
        arrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        arrowButton.tintColor = .am(.base(.white))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        addGestureRecognizer(tapGesture)
    }

    func configure(with title: String) {
        titleLabel.text = title
        arrowButton.isHidden = false
    }
    
    func configureWithoutArrow(with title: String) {
        titleLabel.text = title
        arrowButton.isHidden = true
    }
    
    @objc private func headerTapped() {
        delegate?.sectionHeaderViewTapped(self)
    }
}
