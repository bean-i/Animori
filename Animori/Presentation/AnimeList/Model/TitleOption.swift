//
//  TitleOption.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation

enum TitleOption {
    case seasonNow
    case complete
    case movie
    case search(String)
    
    var displayName: String {
        switch self {
        case .seasonNow: return "이번 시즌 애니메이션"
        case .complete: return "완결 애니메이션"
        case .movie: return "극장판 애니메이션"
        case .search(let searchKeyword): return searchKeyword
        }
    }
}
