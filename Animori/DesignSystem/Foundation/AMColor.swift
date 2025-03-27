//
//  AMColor.swift
//  Animori
//
//  Created by 이빈 on 3/27/25.
//

import UIKit

enum AMColor {
    case base(Base)
    case age(Age)
    
    var color: UIColor {
        switch self {
        case .base(let base):
            return base.color
        case .age(let age):
            return age.color
        }
    }
}

extension AMColor {
    enum Base {
        case black
        case white
        
        var color: UIColor {
            switch self {
            case .black: return .amBlack
            case .white: return .amWhite
            }
        }
    }
    
    enum Age {
        case all
        case children
        case lowteen
        case highteen
        case restricted
        case adult
        
        var color: UIColor {
            switch self {
            case .all: return .systemGreen
            case .children: return .systemYellow
            case .lowteen: return .systemBlue
            case .highteen: return .systemOrange
            case .restricted: return .systemPink
            case .adult: return .systemRed
            }
        }
    }
}
