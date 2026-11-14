//  AdMobBannerView.swift

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String

    /// Info.plist に `AdUnitID` が無い場合はクラッシュさせず nil を返す。
    init?(bundle: Bundle = .main) {
        guard let adUnitID = bundle.infoDictionary?["AdUnitID"] as? String, !adUnitID.isEmpty else {
            print("AdUnitID not found in Info dictionary")
            return nil
        }
        self.adUnitID = adUnitID
    }

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

/// 設定で有効な場合のみバナーを表示する。
struct BannerAdSlot: View {
    var body: some View {
        if AppConfig.isBannerAdEnabled, let banner = AdMobBannerView() {
            banner
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
        }
    }
}
