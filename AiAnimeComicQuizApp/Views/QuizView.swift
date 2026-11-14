//  QuizView.swift

import SwiftUI

struct QuizView: View {
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: QuizViewModel
    @State private var isShowingQuitConfirmation = false

    init(anime: Anime) {
        _viewModel = StateObject(wrappedValue: QuizViewModel(anime: anime))
    }

    var body: some View {
        content
            .background(Theme.screenBackground.ignoresSafeArea())
            .navigationTitle(viewModel.anime.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(viewModel.phase == .playing)
            .toolbar {
                if viewModel.phase == .playing {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            isShowingQuitConfirmation = true
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .accessibilityLabel(Text("クイズを中断"))
                    }
                }
            }
            .confirmationDialog("クイズを中断しますか？", isPresented: $isShowingQuitConfirmation, titleVisibility: .visible) {
                Button("中断して作品選択に戻る", role: .destructive) { router.pop() }
                Button("続ける", role: .cancel) {}
            } message: {
                Text("ここまでの回答は保存されません。")
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.phase {
        case .playing:
            if let question = viewModel.currentQuestion {
                QuestionContent(viewModel: viewModel, question: question)
            }
        case .finished:
            ScoreView(viewModel: viewModel)
        case .empty:
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                Text("問題を読み込めませんでした")
                    .font(.headline)
                Button("作品選択に戻る") { router.pop() }
                    .buttonStyle(SecondaryButtonStyle())
                    .padding(.horizontal, 48)
            }
        }
    }
}

private struct QuestionContent: View {
    @ObservedObject var viewModel: QuizViewModel
    let question: QuizQuestion

    private static let labels = ["A", "B", "C", "D", "E", "F"]

    var body: some View {
        VStack(spacing: 16) {
            header

            ScrollView {
                VStack(spacing: 20) {
                    questionCard

                    VStack(spacing: 12) {
                        ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                            AnswerButton(
                                label: Self.labels[index % Self.labels.count],
                                title: option,
                                state: answerState(for: index)
                            ) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    viewModel.select(index)
                                }
                                Haptics.notify(question.isCorrect(index) ? .success : .error)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }

            if let isCorrect = viewModel.lastAnswerWasCorrect {
                feedbackBar(isCorrect: isCorrect)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.top, 8)
        .animation(.easeOut(duration: 0.2), value: viewModel.hasAnswered)
        // 問題が切り替わったら新しいビューとして描画し、遷移アニメーションをかける
        .id(question.id)
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity))
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text("第\(viewModel.currentIndex + 1)問")
                    .font(.headline)
                Text("/ \(viewModel.totalCount)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Label("\(viewModel.score)", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(Theme.correct)
                    .accessibilityLabel(Text("正解数 \(viewModel.score)"))
            }
            ProgressView(value: viewModel.progress)
                .tint(.accentColor)
        }
        .padding(.horizontal)
    }

    private var questionCard: some View {
        Text(question.text)
            .font(.title3.weight(.semibold))
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, minHeight: 120)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .fill(Theme.cardBackground)
                    .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
            )
    }

    private func answerState(for index: Int) -> AnswerButton.State {
        guard let selected = viewModel.selectedIndex else { return .idle }
        if question.isCorrect(index) { return .correct }
        if index == selected { return .wrong }
        return .dimmed
    }

    private func feedbackBar(isCorrect: Bool) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                Text(isCorrect ? "お見事！正解です！" : "残念...不正解です")
            }
            .font(.title3.weight(.bold))
            .foregroundColor(isCorrect ? Theme.correct : Theme.wrong)

            if !isCorrect {
                Text("正解：\(question.correctOption)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            CustomButton(
                title: viewModel.isLastQuestion ? "結果を見る" : "次の問題へ",
                systemImage: viewModel.isLastQuestion ? "flag.checkered" : "arrow.right"
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.next()
                }
            }
        }
        .padding()
        .background(.regularMaterial)
    }
}
