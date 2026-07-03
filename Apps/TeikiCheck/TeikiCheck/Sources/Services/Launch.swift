import Foundation
import SwiftData

/// 起動引数（スクリーンショット撮影・デモ用）。
/// すべてローカルの起動引数で制御し、通常のユーザー利用時には一切影響しない。
enum Launch {
    private static var args: [String] { ProcessInfo.processInfo.arguments }

    /// 広告バナーを非表示（スクショ撮影用）。
    static var hideAds: Bool { args.contains("-hideAds") }
    /// デモ用のサンプル値を流し込む（通常シナリオ or 区間内加算シナリオ）。
    static var isDemo: Bool { args.contains("-demo") || args.contains("-demoExtra") }
    /// 区間内の追加利用で黒字化するシナリオ。
    private static var isDemoExtra: Bool { args.contains("-demoExtra") }
    /// 起動時にペイウォールを表示。
    static var showPaywall: Bool { args.contains("-showPaywall") }
    /// オンボーディングを強制表示（スクショ撮影用）。
    static var forceOnboarding: Bool { args.contains("-forceOnboarding") }

    /// 起動時に選択するタブ（"history" で履歴タブ）。
    static var startTab: String? {
        guard let i = args.firstIndex(of: "-startTab"), i + 1 < args.count else { return nil }
        return args[i + 1]
    }

    /// 計算画面に流し込むデモ入力。
    static var demoInput: TeikiInput {
        if isDemoExtra {
            // 通勤だけでは赤字（15往復×400円=6,000円 < 定期8,000円）だが、
            // 区間内の追加利用（250円×往復×月6回=3,000円）を足すと黒字化する例。
            return TeikiInput(
                oneWayFare: 200,
                passPrice: 8000,
                period: .oneMonth,
                commuteDaysPerMonth: 15,
                extraTrips: [ExtraTrip(name: "休日のおでかけ", oneWayFare: 250, isRoundTrip: true, timesPerMonth: 6)]
            )
        }
        // 標準シナリオ（「買うべき！」になる例）。
        return TeikiInput(
            oneWayFare: 220,
            passPrice: 6930,
            period: .oneMonth,
            commuteDaysPerMonth: 20,
            extraTrips: [ExtraTrip(name: "休日のおでかけ", oneWayFare: 300, isRoundTrip: true, timesPerMonth: 4)]
        )
    }

    /// 履歴が空のときだけ、デモ用の保存区間を投入する。
    @MainActor
    static func seedHistoryIfNeeded(_ context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<SavedRoute>())) ?? 0
        guard count == 0 else { return }
        let samples: [(String, TeikiInput)] = [
            ("自宅 ⇔ 会社", TeikiInput(oneWayFare: 220, passPrice: 6930, period: .oneMonth, commuteDaysPerMonth: 20)),
            ("自宅 ⇔ 大学", TeikiInput(oneWayFare: 320, passPrice: 34600, period: .sixMonths, commuteDaysPerMonth: 18)),
            ("実家までの帰省ルート", TeikiInput(oneWayFare: 480, passPrice: 24800, period: .threeMonths, commuteDaysPerMonth: 8)),
        ]
        for (name, input) in samples {
            context.insert(SavedRoute(name: name, input: input))
        }
        try? context.save()
    }
}
