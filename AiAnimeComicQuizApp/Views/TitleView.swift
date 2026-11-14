// TitleView.swift

import SwiftUI

struct TitleView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            background

            VStack(spacing: 12) {
                Spacer()

                titleText("AI", size: 72)
                titleText("漫画&アニメ", size: 44)
                titleText("QUIZ", size: 72)

                Text("AIが作った問題で、好きな作品の知識を試そう")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)

                Spacer()

                CustomButton(title: "START", systemImage: "play.fill") {
                    Haptics.tap()
                    router.push(.animeList)
                }
                .accessibilityLabel(Text("クイズを開始"))
                .padding(.horizontal, 8)

                HStack(spacing: 24) {
                    Button("利用規約") { router.push(.terms) }
                    Button("プライバシーポリシー") { router.push(.privacyPolicy) }
                }
                .font(.footnote.weight(.medium))
                .foregroundColor(.white.opacity(0.85))
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var background: some View {
        GeometryReader { geometry in
            Image("TitleImage")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.black.opacity(0.15), .black.opacity(0.35), .black.opacity(0.75)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private func titleText(_ text: String, size: CGFloat) -> some View {
        Text(text)
            .font(.system(size: size, weight: .black, design: .rounded))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .shadow(color: .black.opacity(0.6), radius: 8, x: 0, y: 4)
    }
}
