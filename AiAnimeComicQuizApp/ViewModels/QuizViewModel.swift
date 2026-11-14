//  QuizViewModel.swift

import Foundation

@MainActor
final class QuizViewModel: ObservableObject {
    enum Phase: Equatable {
        case playing
        case finished
        case empty
    }

    struct AnswerRecord: Identifiable {
        let question: QuizQuestion
        let selectedIndex: Int

        var id: UUID { question.id }
        var isCorrect: Bool { question.isCorrect(selectedIndex) }
        var selectedOption: String { question.options[selectedIndex] }
    }

    static let questionsPerRound = 10

    let anime: Anime

    @Published private(set) var phase: Phase = .playing
    @Published private(set) var questions: [QuizQuestion] = []
    @Published private(set) var currentIndex = 0
    /// 現在の問題で選んだ選択肢（未回答なら nil）
    @Published private(set) var selectedIndex: Int?
    @Published private(set) var answers: [AnswerRecord] = []
    @Published private(set) var isNewBest = false

    private let allQuestions: [QuizQuestion]
    private let scoreStore: ScoreStore

    init(anime: Anime, loader: QuizLoading = QuizDataManager(), scoreStore: ScoreStore = .shared) {
        self.anime = anime
        self.scoreStore = scoreStore
        self.allQuestions = loader.loadQuestions(for: anime)
        startNewRound()
    }

    // MARK: - State

    var currentQuestion: QuizQuestion? {
        questions.indices.contains(currentIndex) ? questions[currentIndex] : nil
    }

    var totalCount: Int { questions.count }
    var score: Int { answers.filter(\.isCorrect).count }
    var hasAnswered: Bool { selectedIndex != nil }
    var isLastQuestion: Bool { currentIndex >= questions.count - 1 }
    var mistakes: [AnswerRecord] { answers.filter { !$0.isCorrect } }

    /// 回答済みの問題数を含めた進捗（0...1）
    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(currentIndex + (hasAnswered ? 1 : 0)) / Double(totalCount)
    }

    var lastAnswerWasCorrect: Bool? {
        guard let selectedIndex, let currentQuestion else { return nil }
        return currentQuestion.isCorrect(selectedIndex)
    }

    // MARK: - Actions

    func startNewRound() {
        questions = allQuestions
            .shuffled()
            .prefix(Self.questionsPerRound)
            .map { $0.withShuffledOptions() }
        currentIndex = 0
        selectedIndex = nil
        answers = []
        isNewBest = false
        phase = questions.isEmpty ? .empty : .playing
    }

    func select(_ index: Int) {
        guard phase == .playing, selectedIndex == nil, let question = currentQuestion,
              question.options.indices.contains(index) else { return }
        selectedIndex = index
        answers.append(AnswerRecord(question: question, selectedIndex: index))
    }

    func next() {
        guard hasAnswered else { return }
        if isLastQuestion {
            finish()
        } else {
            currentIndex += 1
            selectedIndex = nil
        }
    }

    private func finish() {
        isNewBest = scoreStore.save(score: score, total: totalCount, for: anime)
        phase = .finished
    }
}
