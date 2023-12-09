//  CustomText.swift

import SwiftUI

struct CustomText: View {
    var text: String
    var isTitle: Bool = false
    var fontSize: CGFloat = 20
    var fontWeight: Font.Weight = .regular
    var shadowColor: Color = .clear
    var shadowRadius: CGFloat = 0
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 0

    var body: some View {
        Text(text)
            .font(.system(size: isTitle ? 60 : fontSize))
            .fontWeight(isTitle ? .heavy : fontWeight)
            .foregroundColor(shadowColor == .black ? .white : Color.gray.opacity(0.95))
            .padding()
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
}
