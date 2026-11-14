//  AnimeListView.swift

import SwiftUI

struct AnimeListView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var scoreStore: ScoreStore
    @State private var searchText = ""

    private var filteredAnime: [Anime] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return AnimeData.all }
        return AnimeData.all.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        List {
            if searchText.isEmpty {
                Section {
                    Button {
                        if let anime = AnimeData.all.randomElement() {
                            Haptics.tap()
                            router.push(.quiz(anime))
                        }
                    } label: {
                        Label("おまかせで挑戦", systemImage: "shuffle")
                            .font(.headline)
                    }
                }
            }

            Section {
                ForEach(filteredAnime) { anime in
                    Button {
                        router.push(.quiz(anime))
                    } label: {
                        AnimeRow(anime: anime, record: scoreStore.record(for: anime))
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                Text("\(filteredAnime.count) 作品")
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if filteredAnime.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                    Text("「\(searchText)」に一致する作品はありません")
                }
                .foregroundColor(.secondary)
            }
        }
        .searchable(text: $searchText, prompt: "作品名で検索")
        .navigationTitle("作品を選択")
    }
}

private struct AnimeRow: View {
    let anime: Anime
    let record: ScoreStore.Record?

    var body: some View {
        HStack(spacing: 14) {
            Text(String(anime.title.prefix(1)))
                .font(.title3.weight(.heavy))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(Theme.primaryGradient)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(anime.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if record?.isPerfect == true {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .accessibilityLabel(Text("満点達成"))
            }
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    private var subtitle: String {
        guard let record else { return "未挑戦" }
        return "ベスト \(record.bestScore)/\(record.total) ・ \(record.playCount)回プレイ"
    }
}
