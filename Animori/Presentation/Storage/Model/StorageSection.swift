//
//  StorageSection.swift
//  Animori
//
//  Created by 이빈 on 4/12/25.
//

import Foundation
import RxDataSources

enum StorageSectionItem {
    case watching(AnimeSaveStatusTable)
    case planned(AnimeSaveStatusTable)
    case finished(AnimeSaveStatusTable)
}

struct StorageSection {
    var header: String
    var items: [StorageSectionItem]
}

extension StorageSection: SectionModelType {
    typealias Item = StorageSectionItem
    
    init(original: StorageSection, items: [StorageSectionItem]) {
        self = original
        self.items = items
    }
}
