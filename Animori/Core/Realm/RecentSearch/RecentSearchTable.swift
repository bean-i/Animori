//
//  RecentSearchTable.swift
//  Animori
//
//  Created by 이빈 on 4/5/25.
//

import Foundation
import RealmSwift

class RecentSearchTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var keyword: String
    @Persisted var timestamp: Date
    
    convenience init(keyword: String, timestamp: Date) {
        self.init()
        self.keyword = keyword
        self.timestamp = timestamp
    }
}
