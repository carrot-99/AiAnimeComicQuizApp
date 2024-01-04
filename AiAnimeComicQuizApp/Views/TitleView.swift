// TitleView.swift

import SwiftUI

struct TitleView: View {
    @Binding var isQuizActive: Bool
    @Binding var isTitleViewActive: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("TitleImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
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
    }

    private func createTitleText(_ text: String, width: CGFloat) -> some View {
        let fontSize = min(width / 5, 60)
        return Text(text)
            .font(.system(size: fontSize, weight: .bold, design: .rounded)) // フォントの変更
            .foregroundColor(Color.white) // テキストの色を白に変更
            .padding(5) // テキストの周りに余白を追加
            .background(Color.black.opacity(0.5)) // 背景に半透明の黒色オーバーレイを追加
            .cornerRadius(10) // 角を丸くする
            .shadow(color: .black.opacity(0.7), radius: 10, x: 5, y: 5) // 影をより強調
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
