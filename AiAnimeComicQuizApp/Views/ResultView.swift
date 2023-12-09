//  ResultView.swift

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: QuizViewModel
    var selectedAnswer: Int?
    var correctAnswer: Int
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text("結果")
                .font(.largeTitle)
                .fontWeight(.bold)

            if let selectedOption = viewModel.selectedOption, let question = viewModel.currentQuestion  {
                Group {
                    Text("選択した答え")
                    Text("\(selectedOption)")
                        .font(.title2)
                    Text("正解")
                    Text("\(question.options[correctAnswer-1])")
                        .font(.title2)
                        .padding()
                }
                
                Text(viewModel.selectedAnswer == correctAnswer ? "お見事！正解です！" : "残念...不正解です")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(selectedAnswer == correctAnswer ? .green : .red)
            } else {
                Text("解答が選択されていません")
                    .font(.headline)
            }
            
            CustomButton(title: "NEXT", action: {
                viewModel.moveToNextQuestion()
                presentationMode.wrappedValue.dismiss()
            })
            .accessibility(label: Text("次の画面へ"))
            .padding()

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarHidden(true)
    }
}
