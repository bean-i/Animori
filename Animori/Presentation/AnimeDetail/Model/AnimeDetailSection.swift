//
//  AnimeDetailSection.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

enum AnimeDetailSectionItem {
    case review(any AnimeReviewProtocol)
    case character(any AnimeCharacterProtocol)
    case ott(AnimeDetailOTT)
    case recommend(any AnimeRecommendProtocol)
}

struct AnimeDetailSection {
    let header: String
    var items: [AnimeDetailSectionItem]
}

extension AnimeDetailSection: SectionModelType {
    typealias Item = AnimeDetailSectionItem
    
    init(original: AnimeDetailSection, items: [Item]) {
        self = original
        self.items = items
    }
}
