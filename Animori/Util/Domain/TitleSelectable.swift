//
//  TitleSelectable.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import Foundation

protocol TitleSelectable {
    var titles: [AnimeTitle] { get }
}

extension TitleSelectable {
    func preferredTitle() -> String {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        let preferredOrder = lang == "ja" ? ["Japanese", "English"] : ["English", "Japanese"]

        return preferredOrder
            .compactMap { type in titles.first(where: { $0.type == type })?.title }
            .first ?? titles.first?.title ?? ""
    }
}
