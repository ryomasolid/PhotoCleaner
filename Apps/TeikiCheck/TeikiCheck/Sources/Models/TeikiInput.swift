import Foundation

/// 定期券がお得かどうかを判定するための入力一式。
struct TeikiInput: Codable, Hashable {
    /// 片道の普通運賃（円）。
    var oneWayFare: Int = 0
    /// 定期代（円）。選択中の期間ぶんの金額。
    var passPrice: Int = 0
    /// 定期の有効期間。
    var period: TeikiPeriod = .oneMonth
    /// 通勤・通学する日数（1 ヶ月あたり）。1 日 1 往復として計算する。
    var commuteDaysPerMonth: Int = 20
    /// 定期区間内での追加利用。
    var extraTrips: [ExtraTrip] = []

    /// 数値がひととおり埋まっていて計算する意味があるか。
    var isCalculable: Bool { oneWayFare > 0 && passPrice > 0 }
}
