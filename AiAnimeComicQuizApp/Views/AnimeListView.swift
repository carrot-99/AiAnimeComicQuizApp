//  AnimeListView.swift

import SwiftUI

struct AnimeListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isTitleViewActive: Bool
    @Binding var isQuizActive: Bool
    
    var borderColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.25) : Color.gray.opacity(0.5)
    }
    
    init(isTitleViewActive: Binding<Bool>, isQuizActive: Binding<Bool>) {
        self._isTitleViewActive = isTitleViewActive
        self._isQuizActive = isQuizActive
    }

    var body: some View {
        VStack {
            List(1...AnimeData.animeTitles.count, id: \.self) { index in
                listItem(for: index)
            }
            
            Spacer()
                .frame(height: 50) 
        }
        .navigationTitle("漫画・アニメを選択")
    }

    @ViewBuilder
    private func listItem(for index: Int) -> some View {
        NavigationLink(destination: QuizView(animeNumber: index, isTitleViewActive: $isTitleViewActive, isQuizActive: $isQuizActive)) {
            Text(AnimeData.animeTitles[index - 1])
        }
        .padding()
        .background(colorScheme == .dark ? Color(white: 0.1) : Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
        .shadow(color: colorScheme == .dark ? Color.gray.opacity(0.8) : Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
