//  TermsAgreementView.swift

import SwiftUI

struct TermsAgreementView: View {
    @Binding var isShowingTerms: Bool
    @Binding var hasAgreedToTerms: Bool
    @State private var isShowingTermsView = false
    @State private var isShowingPrivacyPolicyView = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                        .padding()
                    Text("本アプリでは、お客様の体験を向上させるために広告を表示します。詳細については、以下の利用規約とプライバシーポリシーをご確認ください。")

                    HStack {
                        Spacer()
                        
                        Button("利用規約") {
                            isShowingTermsView = true
                        }
                        .sheet(isPresented: $isShowingTermsView) {
                            TermsView()
                        }

                        Spacer()

                        Button("プライバシーポリシー") {
                            isShowingPrivacyPolicyView = true
                        }
                        .sheet(isPresented: $isShowingPrivacyPolicyView) {
                            PrivacyPolicyView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }

            // 同意するボタン
            Button("同意する") {
                self.hasAgreedToTerms = true
                self.isShowingTerms = false
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}
