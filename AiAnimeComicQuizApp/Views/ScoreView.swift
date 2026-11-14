//  ScoreView.swift

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject private var router: AppRouter
    @ObservedObject var viewModel: QuizViewModel
    @State private var animatedRatio: Double = 0

    private var ratio: Double {
        viewModel.totalCount == 0 ? 0 : Double(viewModel.score) / Double(viewModel.totalCount)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                scoreRing
                    .padding(.top, 24)

                VStack(spacing: 8) {
                    if viewModel.isNewBest {
                        Label("ベストスコア更新！", systemImage: "star.fill")
                            .font(.subheadline.weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.orange))
                    }
                    Text(rankMessage)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 12) {
                    CustomButton(title: "もう一度挑戦", systemImage: "arrow.clockwise") {
                        withAnimation { viewModel.startNewRound() }
                    }
                    Button("作品選択に戻る") { router.pop() }
                        .buttonStyle(SecondaryButtonStyle())
                    Button("TOPに戻る") { router.popToRoot() }
                        .font(.subheadline)
                        .padding(.top, 4)
                }

                if !viewModel.mistakes.isEmpty {
                    mistakesSection
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) {
                animatedRatio = ratio
            }
        }
    }

    private var scoreRing: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.15), lineWidth: 16)
            Circle()
                .trim(from: 0, to: animatedRatio)
                .stroke(Theme.primaryGradient, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("\(viewModel.score)")
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                Text("/ \(viewModel.totalCount) 問正解")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 180, height: 180)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(viewModel.totalCount)問中\(viewModel.score)問正解"))
    }

    private var rankMessage: String {
        switch ratio {
        case 1: return "パーフェクト！\n真のファンです 👑"
        case 0.8...: return "すばらしい！\nかなりの通ですね"
        case 0.5...: return "なかなかの実力！"
        case 0.3...: return "あと一歩！"
        default: return "もう一度読み返してみよう"
        }
    }

    private var mistakesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("間違えた問題（\(viewModel.mistakes.count)）")
                .font(.headline)

            ForEach(viewModel.mistakes) { record in
                VStack(alignment: .leading, spacing: 8) {
                    Text(record.question.text)
                        .font(.subheadline.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Label(record.selectedOption, systemImage: "xmark.circle.fill")
                        .font(.footnote)
                        .foregroundColor(Theme.wrong)
                    Label(record.question.correctOption, systemImage: "checkmark.circle.fill")
                        .font(.footnote)
                        .foregroundColor(Theme.correct)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                        .fill(Theme.cardBackground)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }
}
