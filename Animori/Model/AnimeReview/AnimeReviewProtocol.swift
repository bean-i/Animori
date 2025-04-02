//
//  AnimeReviewProtocol.swift
//  Animori
//
//  Created by 이빈 on 4/2/25.
//

import Foundation

protocol AnimeReviewProtocol: Equatable {
    var name: String { get }
    var score: String { get }
    var review: String { get }
}
