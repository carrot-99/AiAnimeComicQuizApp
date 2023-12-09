//  AdMobBannerView.swift

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String
    
    init() {
        if let adUnitID = Bundle.main.infoDictionary?["AdUnitID"] as? String {
            self.adUnitID = adUnitID
        } else {
            fatalError("AdUnitID not found in Info dictionary")
        }
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
