//  AdMobBannerView.swift

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String
    
    init() {
        self.adUnitID = ProcessInfo.processInfo.environment["ADMOB_AD_UNIT_ID"] ?? "ca-app-pub-3940256099942544/2934735716"
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = self.adUnitID
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            banner.rootViewController = rootVC
        }

        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // バナー広告のビューを更新する必要がある場合に実装
    }
}
