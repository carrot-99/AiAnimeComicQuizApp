//  QuizView.swift

import SwiftUI

struct QuizView: View {
    @State private var showingResult = false
    @StateObject var viewModel: QuizViewModel
    @Environment(\.colorScheme) var colorScheme
    var animeNumber: Int
    @Binding var isTitleViewActive: Bool
    @Binding var isQuizActive: Bool
    
    var borderColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.25) : Color.gray.opacity(0.5)
    }
    
    init(animeNumber: Int, isTitleViewActive: Binding<Bool>, isQuizActive: Binding<Bool>) {
        self.animeNumber = animeNumber
        self._isTitleViewActive = isTitleViewActive
        self._isQuizActive = isQuizActive
        _viewModel = StateObject(wrappedValue: QuizViewModel(animeNumber: animeNumber))
    }

    var body: some View {
        VStack {
            Spacer()
            
            if let question = viewModel.currentQuestion {
                CustomText(
                    text: question.question,
                    fontSize: 20,
                    fontWeight: .regular,
                    shadowColor: colorScheme == .dark ? .black : .clear,
                    shadowRadius: colorScheme == .dark ? 10 : 0
                )
                Spacer()
                VStack(spacing: 10) {
                    ForEach(0..<question.options.count, id: \.self) { index in
                        CustomButton(title: question.options[index]) {
                            viewModel.selectAnswer(index)
                            showingResult = true
                        }
                        .padding(.horizontal, 10)
                    }
                }
            } else {
                Text("問題を読み込み中...")
            }
            
            NavigationLink(
                destination: ScoreView(
                    score: viewModel.score,
                    isTitleViewActive: $isTitleViewActive,
                    isQuizActive: $isQuizActive
                ),
                isActive: $viewModel.showScoreView
            ) {
                EmptyView()
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            viewModel.selectRandomQuestion()
        }
        .onDisappear {
            isQuizActive = false
//            isTitleViewActive = true
        }
        .fullScreenCover(isPresented: $showingResult) {
            ResultView(
                viewModel: viewModel,
                selectedAnswer: viewModel.selectedAnswer,
                correctAnswer: viewModel.currentQuestion?.answer ?? 0
            )
        }
    }
}
