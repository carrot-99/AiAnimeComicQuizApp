//  UserSettings.swift

import Foundation

class UserSettings: ObservableObject {
    @Published var hasAgreedToTerms: Bool {
        didSet {
            UserDefaults.standard.set(hasAgreedToTerms, forKey: "hasAgreedToTerms")
        }
    }

    init() {
        self.hasAgreedToTerms = UserDefaults.standard.bool(forKey: "hasAgreedToTerms")
    }
}
