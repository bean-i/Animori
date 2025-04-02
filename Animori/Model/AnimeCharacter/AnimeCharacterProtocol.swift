//
//  AnimeCharacterProtocol.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

protocol AnimeCharacterProtocol: Equatable {
    var id: Int { get }
    var name: String { get }
    var image: String { get }
}
