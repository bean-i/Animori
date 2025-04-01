//
//  AppAppearance.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import UIKit

final class AppAppearance {
    
    static func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .amBlack
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.amWhite]
        UINavigationBar.appearance().tintColor = .amWhite
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
}
