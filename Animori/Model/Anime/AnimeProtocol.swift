//
//  AnimeProtocol.swift
//  Animori
//
//  Created by 이빈 on 3/29/25.
//

import Foundation

protocol AnimeProtocol: Equatable {
    var id: Int { get }
    var title: String { get }
    var image: String { get }
    var genre: [String] { get }
    var rate: String { get }
    var popularity: Int { get }
    var favorites: Int { get }
}
