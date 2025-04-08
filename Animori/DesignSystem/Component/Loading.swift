//
//  Loading.swift
//  Animori
//
//  Created by 이빈 on 4/3/25.
//

import UIKit
import SnapKit

final class Loading {
    static let shared = Loading()
    
    private init() { }
    
    func showLoading(in view: UIView) {
        DispatchQueue.main.async {
            // 이미 로딩 뷰가 있으면 추가하지 않음
            if view.subviews.contains(where: { $0 is UIActivityIndicatorView }) {
                return
            }
            
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            overlayView.tag = 1
            view.addSubview(overlayView)
            
            overlayView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            // 액티비티 인디케이터 생성
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.color = .white
            loadingIndicator.startAnimating()
            view.addSubview(loadingIndicator)
            
            loadingIndicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    func hideLoading(from view: UIView) {
        DispatchQueue.main.async {
            view.subviews
                .filter { $0 is UIActivityIndicatorView || $0.tag == 1 }
                .forEach { $0.removeFromSuperview() }
        }
    }
}
