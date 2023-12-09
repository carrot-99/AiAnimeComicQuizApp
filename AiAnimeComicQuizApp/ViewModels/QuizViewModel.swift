//  QuizViewModel.swift

import Foundation

class QuizViewModel: ObservableObject {
    @Published var currentQuestion: QuizQuestion?
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var navigateToScoreView = false
    @Published var navigateToResult = false
    @Published var showScoreView = false
    @Published var isQuizActive = false
    var selectedAnswer: Int?
    var selectedOption: String?
    private var quizDataManager = QuizDataManager()
    private var questions: [QuizQuestion] = []
    private var randomQuestions: [QuizQuestion] = []
    
    init(animeNumber: Int) {
        loadQuestions(for: animeNumber)
        generateRandomQuestionSet()
    }

    func loadQuestions(for animeNumber: Int) {
        questions = quizDataManager.loadQuestions(for: animeNumber)
        randomizeQuestions()
        generateRandomQuestionSet()
    }
    
    func generateRandomQuestionSet() {
        randomQuestions = Array(questions.shuffled().prefix(10)) // 最大10問に制限
    }

    func parseCSV(_ contents: String) {
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
    }
    
    func randomizeQuestions() {
        randomQuestions = questions.shuffled()
        selectRandomQuestion()
    }

    func selectRandomQuestion() {
        if currentQuestionIndex < randomQuestions.count {
            currentQuestion = randomQuestions[currentQuestionIndex]
        } else {
            showScoreView = true
        }
    }
    
    func selectAnswer(_ answer: Int) {
        if let question = currentQuestion, answer < question.options.count {
            selectedOption = question.options[answer]
        }
        selectedAnswer = answer + 1
        if (answer + 1) == currentQuestion?.answer {
            score += 1
        }

        navigateToResult = true
    }

    func moveToNextQuestion() {
        if currentQuestionIndex < randomQuestions.count - 1 {
            currentQuestionIndex += 1
            selectRandomQuestion()
        } else {
            showScoreView = true
        }
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        showScoreView = false
        isQuizActive = false
        selectRandomQuestion()
    }
    
    func resetNavigation() {
        isQuizActive = false
        resetQuiz()
    }
}
