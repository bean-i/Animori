//
//  AnimoriTabBarController.swift
//  Animori
//
//  Created by 이빈 on 4/6/25.
//

import UIKit

final class AnimoriTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .amDarkGray
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .am(.base(.white))
    }
    
}
