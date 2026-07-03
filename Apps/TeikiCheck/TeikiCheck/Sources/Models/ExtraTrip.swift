import Foundation

/// 定期区間「内」での追加利用（途中下車・寄り道・休日のおでかけなど）。
/// 定期を持っていれば区間内の乗車は追加料金ゼロなので、その「浮いた運賃」が
/// 実質的に元取りへ加算される。ここではその 1 パターンを表す。
struct ExtraTrip: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    /// 用途の名前（例：「途中下車で買い物」「休日のおでかけ」）。
    var name: String = ""
    /// 定期がなければ本来かかる片道運賃（円）。
    var oneWayFare: Int = 0
    /// 往復するか（true なら片道運賃 ×2 で計算）。
    var isRoundTrip: Bool = true
    /// 月あたりの利用回数。
    var timesPerMonth: Int = 1

    /// 1 回あたりに浮く運賃（往復なら片道×2）。
    var farePerUse: Int { oneWayFare * (isRoundTrip ? 2 : 1) }

    /// 1 ヶ月あたりに浮く運賃。
    var monthlyValue: Int { farePerUse * timesPerMonth }
}
