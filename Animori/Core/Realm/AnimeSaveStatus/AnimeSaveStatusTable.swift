//
//  AnimeSaveStatusTable.swift
//  Animori
//
//  Created by 이빈 on 4/11/25.
//

import Foundation
import RealmSwift

// 시청 상태
enum AnimeWatchStatus: String, PersistableEnum {
    case completed = "completed"
    case watching = "watching"
    case planToWatch = "planToWatch"
    
    var display: String {
        switch self {
        case .completed:
            return LocalizedStrings.MyLibrary.watched
        case .watching:
            return LocalizedStrings.MyLibrary.watching
        case .planToWatch:
            return LocalizedStrings.MyLibrary.toWatch
        }
    }
}

// 시청 상태 저장 테이블
class AnimeSaveStatusTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var animeId: Int
    @Persisted var animeImage: String
    @Persisted var animeTitle: String
    @Persisted var animeScore: String
    @Persisted var status: AnimeWatchStatus
    @Persisted var timestamp: Date
    
    convenience init(animeId: Int,
                     animeImage: String,
                     animeTitle: String,
                     animeScore: String,
                     status: AnimeWatchStatus,
                     timestamp: Date) {
        self.init()
        self.animeId = animeId
        self.animeImage = animeImage
        self.animeTitle = animeTitle
        self.animeScore = animeScore
        self.status = status
        self.timestamp = timestamp
    }
}
