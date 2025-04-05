//
//  AnimeSearchSection.swift
//  Animori
//
//  Created by 이빈 on 4/4/25.
//

import Foundation
import RxDataSources

enum AnimeSearchSectionItem {
    case recentSearch(String)
    case genreSearch(any AnimeGenreProtocol)
    case topAnime(any AnimeProtocol)
    case topCharacter(any TopCharacterProtocol)
}

struct AnimeSearchSection {
    let header: String
    var items: [AnimeSearchSectionItem]
}

extension AnimeSearchSection: SectionModelType {
    typealias Item = AnimeSearchSectionItem
    
    init(original: AnimeSearchSection, items: [AnimeSearchSectionItem]) {
        self = original
        self.items = items
    }
}
