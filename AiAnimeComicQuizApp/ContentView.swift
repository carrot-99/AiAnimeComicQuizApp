// ContentView.swift

import SwiftUI

struct ContentView: View {
    @State private var isQuizActive = false
    @State private var isTitleViewActive = true
    @State private var isShowingTerms = true
    @StateObject private var userSettings = UserSettings()

    var body: some View {
        ZStack(alignment: .bottom) {
            if userSettings.hasAgreedToTerms {
                NavigationView {
                    if isTitleViewActive {
                        TitleView(isQuizActive: $isQuizActive, isTitleViewActive: $isTitleViewActive)
                    } else {
                        AnimeListView(isTitleViewActive: $isTitleViewActive, isQuizActive: $isQuizActive)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())

//                AdMobBannerView()
//                    .frame(width: UIScreen.main.bounds.width, height: 50)
//                    .background(Color.gray.opacity(0.1))
            } else {
                TermsAgreementView(isShowingTerms: $isShowingTerms, hasAgreedToTerms: $userSettings.hasAgreedToTerms)
            }
        }
    }
}
