//  CustomButton.swift

import SwiftUI

/// アプリ共通のメインボタン。
struct CustomButton: View {
    var title: String
    var systemImage: String?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
    }
}

/// クイズの選択肢ボタン。回答後は正誤に応じて色が変わる。
struct AnswerButton: View {
    enum State {
        case idle
        case correct
        case wrong
        case dimmed
    }

    let label: String
    let title: String
    let state: State
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.headline.monospaced())
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(badgeColor))
                    .foregroundColor(.white)

                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                if let icon {
                    Image(systemName: icon)
                        .font(.title3.weight(.bold))
                        .foregroundColor(badgeColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: state == .idle ? 1 : 2)
            )
            .opacity(state == .dimmed ? 0.5 : 1)
        }
        .buttonStyle(.plain)
        // .disabled だとシステムの減光で正誤カラーが薄くなるため、タップのみ無効化する
        .allowsHitTesting(state == .idle)
        .accessibilityLabel(Text(accessibilityText))
    }

    private var badgeColor: Color {
        switch state {
        case .idle, .dimmed: return .accentColor
        case .correct: return Theme.correct
        case .wrong: return Theme.wrong
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .correct: return Theme.correct.opacity(0.15)
        case .wrong: return Theme.wrong.opacity(0.15)
        case .idle, .dimmed: return Theme.cardBackground
        }
    }

    private var borderColor: Color {
        switch state {
        case .correct: return Theme.correct
        case .wrong: return Theme.wrong
        case .idle, .dimmed: return Color.secondary.opacity(0.25)
        }
    }

    private var icon: String? {
        switch state {
        case .correct: return "checkmark.circle.fill"
        case .wrong: return "xmark.circle.fill"
        case .idle, .dimmed: return nil
        }
    }

    private var accessibilityText: String {
        switch state {
        case .correct: return "\(title)、正解"
        case .wrong: return "\(title)、不正解"
        case .idle, .dimmed: return title
        }
    }
}
