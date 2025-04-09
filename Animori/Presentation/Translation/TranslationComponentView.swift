//
//  TranslationComponentView.swift
//  Animori
//
//  Created by 이빈 on 4/9/25.
//

import SwiftUI
import Translation
import NaturalLanguage

struct TranslationComponentView: View {
    @ObservedObject var reactorWrapper: TranslationViewModelWrapper
    @Binding var isExpanded: Bool
    var onHeightChanged: (() -> Void)?

    @State private var sourceLanguage: Locale.Language?
    @State private var targetLanguage: Locale.Language?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let text = reactorWrapper.sourceText?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
                if #available(iOS 18.0, *) {
                    Text(reactorWrapper.translatedText ?? "phrase_translating")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color(.am(.base(.white))))
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 0)
                        .onAppear {
                            setupLanguages(for: text)
                        }
                        .translationTask { session in
                            do {
                                let result = try await session.translate(text)
                                reactorWrapper.translatedText = result.targetText
                            } catch {
                                reactorWrapper.translatedText = text
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
                Text("phrase_loading")
                    .font(.system(size: 12))
            }
                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func setupLanguages(for text: String) {
        // 번역할 텍스트 언어 감지
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        sourceLanguage = Locale.Language(identifier: recognizer.dominantLanguage?.rawValue ?? "en")
        // 사용자 시스템 언어 감지
        let language = Locale.current.language.languageCode?.identifier
        targetLanguage = Locale.Language(identifier: language ?? "en")
    }
}
