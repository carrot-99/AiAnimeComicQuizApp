//  AnimeData.swift

import Foundation

/// クイズ対象の作品。`id` は CSV ファイル名（quiz{id}.csv）と対応する。
struct Anime: Identifiable, Hashable {
    let id: Int
    let title: String

    var quizFileName: String { "quiz\(id)" }
}

enum AnimeData {
    private static let titles = [
        "タコピーの原罪",
        "ONE PIECE",
        "鋼の錬金術師",
        "DRAGON BALL",
        "スラムダンク",
        "NARUTO",
        "五等分の花嫁",
        "鬼滅の刃",
        "呪術廻戦",
        "SPYxFAMILY",
        "ボボボーボ・ボーボボ"
    ]

    static let all: [Anime] = titles.enumerated().map { Anime(id: $0.offset + 1, title: $0.element) }
}
