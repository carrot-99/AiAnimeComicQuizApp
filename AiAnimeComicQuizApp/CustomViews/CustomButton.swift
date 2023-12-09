//  CustomButton.swift

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
