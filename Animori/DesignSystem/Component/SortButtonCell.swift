//
//  SortButtonCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import SnapKit

final class SortButtonCell: BaseCollectionViewCell {
    
    static let identifier = "SortButtonCell"
    
    private let label = UILabel()
    
    override var isSelected: Bool {
        didSet {
            configureLabel()
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = UIColor.am(.base(.white)).cgColor
        
        label.textAlignment = .center
        label.font = .am(.subtitleMedium)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        
        configureLabel()
    }
    
    func configureData(title: String) {
        label.text = title
        configureLabel()
    }
    
    private func configureLabel() {
        contentView.backgroundColor = isSelected ? .am(.base(.white)) : .am(.base(.black))
        label.textColor = isSelected ? .am(.base(.black)) : .am(.base(.white))
    }
    
    // 셀 크기를 레이블에 맞게 동적으로 조정
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = label.systemLayoutSizeFitting(layoutAttributes.size)
        layoutAttributes.frame.size = CGSize(width: size.width + 20, height: 35) // 좌우 여백 10씩 추가
        return layoutAttributes
    }
}
