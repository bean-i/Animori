//
//  Array+.swift
//  Animori
//
//  Created by 이빈 on 4/1/25.
//

import Foundation

extension Array where Element: AnimeProtocol {
    func removeDuplicates() -> [Element] {
        var seenIds = Set<Int>()
        return self.filter { anime in
            if seenIds.contains(anime.id) {
                return false
            } else {
                seenIds.insert(anime.id)
                return true
            }
        }
    }
}
