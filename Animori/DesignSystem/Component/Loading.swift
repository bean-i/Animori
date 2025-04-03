//
//  Loading.swift
//  Animori
//
//  Created by 이빈 on 4/3/25.
//

import UIKit

final class Loading {
    static let shared = Loading()
    
    private init() { }
    
    func showLoading(in view: UIView) {
        DispatchQueue.main.async {
            if view.subviews.contains(where: { $0 is UIActivityIndicatorView }) {
                return
            }
            
            let contentView = UIView()
            contentView.backgroundColor = .am(.base(.black))
            contentView.frame = view.bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.tag = 1
            
            let loadingIndicatorView = UIActivityIndicatorView(style: .large)
            loadingIndicatorView.center = view.center
            loadingIndicatorView.color = .am(.base(.white))
            loadingIndicatorView.startAnimating()
            
            view.addSubview(contentView)
            view.addSubview(loadingIndicatorView)
        }
    }
    
    func hideLoading(from view: UIView) {
        DispatchQueue.main.async {
            view.subviews.filter { $0 is UIActivityIndicatorView || $0.tag == 1 }.forEach { $0.removeFromSuperview() }
        }
    }
}
