//  QuizQuestion.swift

import Foundation

/// 1問分のクイズデータ。
struct QuizQuestion: Identifiable, Hashable {
    let id: UUID
    let text: String
    let options: [String]
    /// 正解の選択肢のインデックス（0始まり）
    let correctIndex: Int

    init(id: UUID = UUID(), text: String, options: [String], correctIndex: Int) {
        self.id = id
        self.text = text
        self.options = options
        self.correctIndex = correctIndex
    }

    var correctOption: String { options[correctIndex] }

    func isCorrect(_ index: Int) -> Bool { index == correctIndex }

    /// 選択肢の並びをシャッフルしたコピーを返す（正解の位置も追従する）。
    func withShuffledOptions() -> QuizQuestion {
        let order = options.indices.shuffled()
        return QuizQuestion(
            id: id,
            text: text,
            options: order.map { options[$0] },
            correctIndex: order.firstIndex(of: correctIndex) ?? correctIndex
        )
    }
}
