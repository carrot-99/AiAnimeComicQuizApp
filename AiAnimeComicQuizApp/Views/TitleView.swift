// TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var isQuizActive: Bool
    @Binding var isTitleViewActive: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Spacer()
                createTitleText("AI", width: geometry.size.width)
                createTitleText("漫画&アニメ", width: geometry.size.width)
                createTitleText("QUIZ", width: geometry.size.width)
                Spacer()
                NavigationLink(destination: AnimeListView(isTitleViewActive: $isTitleViewActive, isQuizActive: $isQuizActive), isActive: $isQuizActive) {
                    CustomButton(title: "START") {
                        isQuizActive = true
                        isTitleViewActive = false
                    }
                }
                .accessibility(label: Text("クイズを開始"))
                
                legalLinksSection()
                    .padding(.bottom, 10)

                Spacer()
                    .frame(height: 50)
            }
            .padding()
            .edgesIgnoringSafeArea(.all)
        }
    }

    private func createTitleText(_ text: String, width: CGFloat) -> some View {
        let fontSize = min(width / 5, 60)
        return CustomText(
            text: text,
            isTitle: true,
            fontSize: fontSize,
            shadowColor: .black.opacity(0.7),
            shadowRadius: 10,
            shadowX: 5,
            shadowY: 5
        )
    }

    @ViewBuilder
    private func legalLinksSection() -> some View {
        HStack {
            Spacer()
            legalLink("利用規約", destination: TermsView())
            Spacer()
            legalLink("プライバシーポリシー", destination: PrivacyPolicyView())
            Spacer()
        }
    }

    @ViewBuilder
    private func legalLink<T: View>(_ title: String, destination: T) -> some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.caption)
                .foregroundColor(.blue)
        }
    }
}
