//  ScoreStore.swift

import Foundation

/// 作品ごとのベストスコアとプレイ回数を UserDefaults に保存する。
@MainActor
final class ScoreStore: ObservableObject {
    struct Record: Codable, Equatable {
        var bestScore: Int
        var total: Int
        var playCount: Int

        var isPerfect: Bool { total > 0 && bestScore == total }
    }

    static let shared = ScoreStore()

    @Published private(set) var records: [Int: Record]

    private let defaults: UserDefaults
    private let storageKey = "scoreRecords"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Int: Record].self, from: data) {
            records = decoded
        } else {
            records = [:]
        }
    }

    func record(for anime: Anime) -> Record? {
        records[anime.id]
    }

    /// 結果を保存し、ベストスコアを更新したかどうかを返す。
    @discardableResult
    func save(score: Int, total: Int, for anime: Anime) -> Bool {
        var record = records[anime.id] ?? Record(bestScore: 0, total: total, playCount: 0)
        let isNewBest = record.playCount == 0 || score > record.bestScore
        record.playCount += 1
        if isNewBest {
            record.bestScore = score
            record.total = total
        }
        records[anime.id] = record
        persist()
        return isNewBest
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
