//  QuizDataManager.swift

import Foundation

protocol QuizLoading {
    func loadQuestions(for anime: Anime) -> [QuizQuestion]
}

/// バンドル内の CSV（`問題,正解番号(1-4),選択肢1,選択肢2,選択肢3,選択肢4`）を読み込む。
struct QuizDataManager: QuizLoading {
    private static let optionCount = 4
    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadQuestions(for anime: Anime) -> [QuizQuestion] {
        guard let url = bundle.url(forResource: anime.quizFileName, withExtension: "csv") else {
            print("CSVファイルが見つかりません: \(anime.quizFileName).csv")
            return []
        }
        do {
            return Self.parse(try String(contentsOf: url, encoding: .utf8))
        } catch {
            print("CSVファイルの読み込みに失敗しました: \(error)")
            return []
        }
    }

    static func parse(_ contents: String) -> [QuizQuestion] {
        contents
            .components(separatedBy: .newlines)
            .compactMap(parseRow)
    }

    private static func parseRow(_ row: String) -> QuizQuestion? {
        let columns = row
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard columns.count == 2 + optionCount,
              !columns[0].isEmpty,
              let answer = Int(columns[1]),
              (1...optionCount).contains(answer) else {
            return nil
        }
        return QuizQuestion(
            text: columns[0],
            options: Array(columns[2...]),
            correctIndex: answer - 1
        )
    }
}
