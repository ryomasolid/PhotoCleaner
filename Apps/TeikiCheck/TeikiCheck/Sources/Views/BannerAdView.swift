import GoogleMobileAds
import SwiftUI
import UIKit

/// AdMob アダプティブ・アンカー・バナー（画面幅に最適化）。
/// TODO: 本番リリース前に release 用ユニットIDを AdMob で発行した本番IDへ差し替える。
///       現状は Google 公式のテスト用ユニットIDを使用している。
struct BannerAdView: View {
    private static var unitID: String {
        // テスト用バナーユニット（開発・審査中の誤クリック対策）。
        "ca-app-pub-3940256099942544/2934735716"
    }

    private var adSize: GADAdSize {
        GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
    }

    var body: some View {
        Representable(adSize: adSize, unitID: Self.unitID)
            .frame(height: adSize.size.height)
    }

    private struct Representable: UIViewRepresentable {
        let adSize: GADAdSize
        let unitID: String

        func makeUIView(context: Context) -> GADBannerView {
            let banner = GADBannerView(adSize: adSize)
            banner.adUnitID = unitID
            banner.rootViewController = Self.rootViewController()
            banner.load(GADRequest())
            return banner
        }

        func updateUIView(_ uiView: GADBannerView, context: Context) {}

        private static func rootViewController() -> UIViewController? {
            let scene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive } ?? UIApplication.shared.connectedScenes.first as? UIWindowScene
            return scene?.keyWindow?.rootViewController
        }
    }
}
