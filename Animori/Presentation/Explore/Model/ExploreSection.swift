//
//  ExploreSection.swift
//  Animori
//
//  Created by 이빈 on 3/30/25.
//

import Foundation
import RxDataSources

// MARK: - 셀 아이템 열거형
enum ExploreItem {
    case sort(SortOption)
    case topAnime([any AnimeProtocol])
    case seasonAnime(any AnimeProtocol)
    case completeAnime(any AnimeProtocol)
    case shortAnime(any AnimeProtocol)
}

extension ExploreItem: IdentifiableType, Equatable {
    var identity: String {
        switch self {
        case .sort(let sortOption): return "sort_\(sortOption.rawValue)"
        case .topAnime: return "topAnime"
        case .seasonAnime(let anime): return "seasonAnime_\(anime.id)"
        case .completeAnime(let anime): return "completeAnime_\(anime.id)"
        case .shortAnime(let anime): return "shortAnime_\(anime.id)"
        }
    }
    
    static func == (lhs: ExploreItem, rhs: ExploreItem) -> Bool {
        switch (lhs, rhs) {
        case (.sort(let l), .sort(let r)):
            return l == r
        case (.topAnime(let l), .topAnime(let r)):
            let lIds = l.map { $0.id }
            let rIds = r.map { $0.id }
            return lIds == rIds
        case (.seasonAnime(let l), .seasonAnime(let r)):
            return l.id == r.id
        case (.completeAnime(let l), .completeAnime(let r)):
            return l.id == r.id
        case (.shortAnime(let l), .shortAnime(let r)):
            return l.id == r.id
        default:
            return false
        }
    }
}

// MARK: - 섹션 모델
struct ExploreSection {
    var header: String
    var items: [ExploreItem]
}

extension ExploreSection: AnimatableSectionModelType {
    typealias Item = ExploreItem
    
    var identity: String {
        return header
    }
    
    init(original: ExploreSection, items: [ExploreItem]) {
        self = original
        self.items = items
    }
}
