//
//  AnimeCharacterInfoProtocol.swift
//  Animori
//
//  Created by 이빈 on 4/10/25.
//

import Foundation

protocol AnimeCharacterInfoProtocol {
    var name: String { get }
    var kanjiName: String { get }
    var nickname: String { get }
    var favorites: String { get }
    var about: String { get }
}
