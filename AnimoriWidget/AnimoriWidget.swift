//
//  AnimoriWidget.swift
//  AnimoriWidget
//
//  Created by 이빈 on 4/22/25.
//

import WidgetKit
import SwiftUI

// MARK: - Entry
struct AnimeEntry: TimelineEntry {
    let date: Date
    let title: String
    let score: String
    let scoredBy: String
    let favorites: String
    let genres: [String]
    let synopsis: String
    let deeplinkURL: URL?
    let imageURL: String?
}

// MARK: - Provider
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> AnimeEntry {
        AnimeEntry(
            date: Date(),
            title: "플레이스홀더 제목",
            score: "8.5",
            scoredBy: "12,345",
            favorites: "1,234",
            genres: ["드라마", "음악"],
            synopsis: "",
            deeplinkURL: nil,
            imageURL: nil
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (AnimeEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AnimeEntry>) -> Void) {
        Task {
            do {
                let dto = try await fetchRandomAnime()
                let url = URL(string: "animori://anime/\(dto.data.id)")
                let title = dto.data.titles.first(where: { $0.type == "Japanese" })?.title
                    ?? dto.data.titles.first(where: { $0.type == "Default" })?.title
                    ?? dto.data.titles.first?.title
                    ?? "제목 없음"

                let score = dto.data.score != nil ? String(format: "%.1f", dto.data.score!) : "N/A"
                let scoredBy = NumberFormatter.localizedString(from: NSNumber(value: dto.data.scoredBy ?? 0), number: .decimal)
                let favorites = NumberFormatter.localizedString(from: NSNumber(value: dto.data.favorites ?? 0), number: .decimal)

                let entry = AnimeEntry(
                    date: Date(),
                    title: title,
                    score: score,
                    scoredBy: scoredBy,
                    favorites: favorites,
                    genres: dto.data.genres.map { $0.name },
                    synopsis: dto.data.synopsis,
                    deeplinkURL: url,
                    imageURL: dto.data.images.jpg.imageURL
                )

                let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800)))
                completion(timeline)
            } catch {
                let fallbackEntry = AnimeEntry(
                    date: Date(),
                    title: "데이터 로딩 실패",
                    score: "N/A",
                    scoredBy: "0",
                    favorites: "0",
                    genres: [],
                    synopsis: "",
                    deeplinkURL: nil,
                    imageURL: nil
                )
                let timeline = Timeline(entries: [fallbackEntry], policy: .after(Date().addingTimeInterval(600)))
                completion(timeline)
            }
        }
    }

    private func fetchRandomAnime() async throws -> RandomAnimeResponseDTO {
        let url = URL(string: "https://api.jikan.moe/v4/random/anime")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(RandomAnimeResponseDTO.self, from: data)
    }
}

// MARK: - Background Image Loader
struct NetworkImageBackground: View {
    let urlString: String?

    var body: some View {
        if let urlString = urlString,
           let url = URL(string: urlString),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .clipped()
        } else {
            Color.black
        }
    }
}

// MARK: - EntryView
@available(iOS 17.0, *)
struct AnimoriWidgetEntryView: View {
    let entry: AnimeEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            AnimoriSmallWidgetView(entry: entry)
        case .systemMedium:
            AnimoriMediumWidgetView(entry: entry)
        default:
            Text("지원되지 않는 크기입니다.")
        }
    }
}

// MARK: - SmallWidget
@available(iOS 17.0, *)
struct AnimoriSmallWidgetView: View {
    let entry: AnimeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2)
            HStack(spacing: 6) {
                Label("\(entry.score)", systemImage: "star.fill")
                Label("\(entry.favorites)", systemImage: "heart.fill")
            }
            .font(.caption2)
            .foregroundColor(.white)
        }
        .padding()
        .containerBackground(for: .widget) {
            NetworkImageBackground(urlString: entry.imageURL)
                .overlay(Color.black.opacity(0.4))
        }
        .widgetURL(entry.deeplinkURL)
    }
}

// MARK: - MediumWidget
@available(iOS 17.0, *)
struct AnimoriMediumWidgetView: View {
    let entry: AnimeEntry

    var body: some View {
        ZStack {
            VStack {
                // 타이틀
                Text(entry.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                Spacer()
                // 평점 관련 정보
                HStack(spacing: 12) {
                    Label(entry.score, systemImage: "star.fill")
                    Label(entry.scoredBy, systemImage: "person.2.fill")
                    Label(entry.favorites, systemImage: "heart.fill")
                }
                .font(.caption2)
                .foregroundColor(.white)
                
                // 장르 - 둥근 박스
                if !entry.genres.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(entry.genres.prefix(3), id: \.self) { genre in
                            Text(genre)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 12)
        }
        .containerBackground(for: .widget) {
            NetworkImageBackground(urlString: entry.imageURL)
                .overlay(Color.black.opacity(0.4))
        }
        .widgetURL(entry.deeplinkURL)
    }
}

// MARK: - Widget
struct AnimoriWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "AnimoriWidget", provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                AnimoriWidgetEntryView(entry: entry)
            } else {
                Text("iOS 17 이상에서만 지원됩니다.")
            }
        }
        .configurationDisplayName("오늘의 추천 애니")
        .description("평점, 좋아요 수, 장르까지 한눈에!")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
