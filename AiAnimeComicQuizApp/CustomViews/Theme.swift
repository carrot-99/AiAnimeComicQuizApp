//  Theme.swift

import SwiftUI
import UIKit

enum Theme {
    static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.98, green: 0.36, blue: 0.55), Color(red: 0.49, green: 0.33, blue: 0.96)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let correct = Color.green
    static let wrong = Color.red
    static let cornerRadius: CGFloat = 16
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let screenBackground = Color(UIColor.systemGroupedBackground)
}

// MARK: - Button styles

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3.weight(.bold))
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Theme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.accentColor)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius, style: .continuous)
                    .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - Haptics

enum Haptics {
    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
