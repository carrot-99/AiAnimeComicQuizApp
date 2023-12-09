//  QuizDataManager.swift

import Foundation

class QuizDataManager {
    func loadQuestions(for animeNumber: Int) -> [QuizQuestion] {
        let fileName = "quiz\(animeNumber)"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "csv") else {
            print("CSVファイルが見つかりません。")
            return []
        }

        do {
            let contents = try String(contentsOf: url)
            return parseCSV(contents)
        } catch {
            print("CSVファイルの読み込みに失敗しました: \(error)")
            return []
        }
    }

    private func parseCSV(_ contents: String) -> [QuizQuestion] {
        var questions = [QuizQuestion]()
        let rows = contents.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == 6 {
                let question = columns[0]
                if let answer = Int(columns[1]) {
                    let options = Array(columns[2...5])
                    let quizQuestion = QuizQuestion(question: question, answer: answer, options: options)
                    questions.append(quizQuestion)
                }
            }
        }
        return questions
    }
}
