//
//  BaseFSPagerViewCell.swift
//  Animori
//
//  Created by 이빈 on 3/28/25.
//

import UIKit
import FSPagerView

class BaseFSPagerViewCell: FSPagerViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
    
}
