// ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var router = AppRouter()
    @StateObject private var scoreStore = ScoreStore.shared

    var body: some View {
        Group {
            if userSettings.hasAgreedToTerms {
                NavigationStack(path: $router.path) {
                    TitleView()
                        .navigationDestination(for: Route.self, destination: destination)
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    BannerAdSlot()
                }
                .transition(.opacity)
            } else {
                TermsAgreementView {
                    withAnimation { userSettings.hasAgreedToTerms = true }
                }
            }
        }
        .environmentObject(router)
        .environmentObject(scoreStore)
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .animeList:
            AnimeListView()
        case .quiz(let anime):
            QuizView(anime: anime)
        case .terms:
            TermsView()
        case .privacyPolicy:
            PrivacyPolicyView()
        }
    }
}
