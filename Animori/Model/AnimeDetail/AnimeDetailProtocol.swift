//
//  AnimeDetailProtocol.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

protocol AnimeDetailProtocol: Equatable {
    var id: Int { get }
    var title: String { get }
    var image: String { get }
    var genre: [String] { get }
    var rate: String { get }
    var age: String { get }
    var airedPeriod: String { get }
    var plot: String { get }
    var OTT: [AnimeDetailOTT] { get }
}
