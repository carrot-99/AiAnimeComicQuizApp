//  QuizQuestion.swift

import Foundation

struct QuizQuestion: Equatable {
    var question: String
    var answer: Int
    var options: [String]

    static func ==(lhs: QuizQuestion, rhs: QuizQuestion) -> Bool {
        return lhs.question == rhs.question && lhs.answer == rhs.answer && lhs.options == rhs.options
    }
}
