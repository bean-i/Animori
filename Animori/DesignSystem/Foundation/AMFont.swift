//
//  AMFont.swift
//  Animori
//
//  Created by 이빈 on 3/27/25.
//

import UIKit

enum AMFont {
    
    // 16pt
    case titleSemibold
    case titleMedium
    case titleRegular
    
    // 14pt
    case subtitleMedium
    
    // 12pt
    case bodyExtrabold
    case bodySemibold
    case bodyRegular
    case bodyMedium
    
    // 10pt
    case captionLight
    
    var size: CGFloat {
        switch self {
        case .titleSemibold, .titleMedium, .titleRegular:
            return 16.0
        case .subtitleMedium:
            return 14.0
        case .bodyExtrabold, .bodySemibold, .bodyRegular, .bodyMedium:
            return 12.0
        case .captionLight:
            return 10.0
        }
    }
    
    var weight: UIFont.Weight {
        switch self {
        case .titleSemibold, .bodySemibold:
            return .semibold
        case .titleMedium, .subtitleMedium, .bodyMedium:
            return .medium
        case .titleRegular, .bodyRegular:
            return .regular
        case .bodyExtrabold:
            return .heavy // extrabold는 heavy로 대체 (필요 시 커스텀 폰트 사용 가능)
        case .captionLight:
            return .light
        }
    }
    
    func font() -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
}
