//
//  TranslationComponentView.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import SwiftUI
import Translation

struct TranslationComponentView: View {
    @ObservedObject var reactorWrapper: TranslationViewModelWrapper
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let text = reactorWrapper.sourceText?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
                if #available(iOS 18.0, *) {
                    Text(reactorWrapper.translatedText ?? LocalizedStrings.Phrase.translating)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.am(.base(.white))))
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 0)
                        .translationTask(
                            source: Locale.Language(identifier: "en"),
                            target: Locale.Language(identifier: Locale.current.language.languageCode?.identifier ?? "en")
                        ) { session in
                            Task { @MainActor in
                                do {
                                    let response = try await session.translate(text)
                                    reactorWrapper.translatedText = response.targetText
                                } catch {
                                    reactorWrapper.translatedText = text
                                }
                            }
                        }
                } else {
                    Text(text)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.am(.base(.white))))
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 0)
                }
            } else {
                Text(LocalizedStrings.Phrase.loading)
                    .font(.system(size: 12))
            }
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
