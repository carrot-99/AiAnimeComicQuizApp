// PrivacyPolicyView.swift

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        LegalDocumentView(title: "プライバシーポリシー", sections: Self.sections)
    }

    static let sections: [LegalSection] = [
        LegalSection(title: "1. はじめに", body: "AI漫画・アニメクイズ（以下「本サービス」といいます）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシーでは、本サービスにおける個人情報の取り扱いについて説明します。"),
        LegalSection(title: "2. 収集する情報", body: "アカウント情報：メールアドレス、ユーザー名など\n利用データ：視聴履歴、アニメの評価、コメントなど\nアクセスログ：利用時のIPアドレス、ブラウザ情報など"),
        LegalSection(title: "3. 情報の利用目的", body: "収集した情報は、以下の目的で利用します。\nサービスの提供および改善\nユーザーサポート\n新機能の開発\n法令遵守"),
        LegalSection(title: "4. 情報の共有", body: "運営者は、以下の場合を除き、ユーザーの個人情報を第三者に開示または共有しません。\nユーザーの同意がある場合\n法令に基づく場合\nユーザーの権利、財産、安全を保護するため必要な場合"),
        LegalSection(title: "5. 情報の保護", body: "運営者は、個人情報の安全性を保護するため、適切な物理的、技術的、管理的な措置を講じます。"),
        LegalSection(title: "6. アクセスおよび訂正", body: "ユーザーは、自己の個人情報にアクセスし、不正確な情報を訂正する権利があります。"),
        LegalSection(title: "7. プライバシーポリシーの変更", body: "運営者は、必要に応じて本ポリシーを変更することがあります。変更があった場合は、本サービス上で通知します。"),
        LegalSection(title: "8. お問い合わせ", body: "本プライバシーポリシーに関するお問い合わせは、[carrot99.official@gmail.com]までお願いします。"),
        LegalSection(title: "9. 広告の利用", body: "本サービスではAdMobを通じて広告を表示しており、ユーザーの興味に基づいた広告が表示される場合があります。このプロセスで収集されるデータについては、Googleのプライバシーポリシーに準拠します。"),
    ]
}
