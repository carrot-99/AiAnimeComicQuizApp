//  TermsAgreementView.swift

import SwiftUI

struct TermsAgreementView: View {
    private enum Sheet: String, Identifiable {
        case terms, privacy
        var id: String { rawValue }
    }

    let onAgree: () -> Void
    @State private var sheet: Sheet?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "sparkles.rectangle.stack.fill")
                .font(.system(size: 64))
                .foregroundStyle(Theme.primaryGradient)

            VStack(spacing: 8) {
                Text("ようこそ！")
                    .font(.largeTitle.weight(.bold))
                Text("AI 漫画&アニメ QUIZ")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.secondary)
            }

            Text("本アプリでは、お客様の体験を向上させるために広告を表示します。詳細については、以下の利用規約とプライバシーポリシーをご確認ください。")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 0) {
                documentRow("利用規約", systemImage: "doc.text") { sheet = .terms }
                Divider().padding(.leading, 48)
                documentRow("プライバシーポリシー", systemImage: "hand.raised") { sheet = .privacy }
            }
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous))

            Spacer()

            CustomButton(title: "同意してはじめる", action: onAgree)
        }
        .padding(24)
        .background(Theme.screenBackground.ignoresSafeArea())
        .sheet(item: $sheet) { sheet in
            LegalSheet {
                switch sheet {
                case .terms: TermsView()
                case .privacy: PrivacyPolicyView()
                }
            }
        }
    }

    private func documentRow(_ title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: systemImage)
                    .frame(width: 24)
                    .foregroundColor(.accentColor)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
