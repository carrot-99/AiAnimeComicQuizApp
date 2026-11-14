//  AppRouter.swift

import SwiftUI

enum Route: Hashable {
    case animeList
    case quiz(Anime)
    case terms
    case privacyPolicy
}

/// 画面遷移を一元管理する。複数の Bool バインディングをバケツリレーしない。
@MainActor
final class AppRouter: ObservableObject {
    @Published var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

enum AppConfig {
    /// バナー広告の表示可否。
    static let isBannerAdEnabled = false
}
