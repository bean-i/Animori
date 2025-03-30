//
//  LocalizedStrings.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

enum LocalizedStrings {
    
    enum Sort {
        static let popular = NSLocalizedString(LocalizedKey.Sort.popular, comment: "")
        static let liked = NSLocalizedString(LocalizedKey.Sort.liked, comment: "")
        static let airing = NSLocalizedString(LocalizedKey.Sort.airing, comment: "")
        static let upcoming = NSLocalizedString(LocalizedKey.Sort.upcoming, comment: "")
    }
    
    enum RecommendOption {
        static let season = NSLocalizedString(LocalizedKey.RecommendOption.season, comment: "")
        static let complete = NSLocalizedString(LocalizedKey.RecommendOption.complete, comment: "")
        static let short = NSLocalizedString(LocalizedKey.RecommendOption.short, comment: "")
    }
    
}
