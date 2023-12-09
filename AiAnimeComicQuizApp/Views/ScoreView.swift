//  ScoreView.swift

import SwiftUI

struct ScoreView: View {
    var score: Int
    @Binding var isTitleViewActive: Bool
    @Binding var isQuizActive: Bool

    var body: some View {
        VStack {
            Text("あなたのスコア: \(score) / 10")
                .font(.largeTitle)

            Button("TOPに戻る") {
                isQuizActive = false
                isTitleViewActive = true
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("結果")
    }
}
