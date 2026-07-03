import Foundation
import SwiftData

/// 保存した区間（計算内容）。履歴として一覧・呼び出しできる。
@Model
final class SavedRoute {
    /// 区間名（例：「自宅 ⇔ 会社」）。
    var name: String
    var oneWayFare: Int
    var passPrice: Int
    /// TeikiPeriod.rawValue（1/3/6）。
    var periodMonths: Int
    var commuteDaysPerMonth: Int
    /// 追加利用は JSON でまとめて保存する（SwiftData のスキーマを単純に保つため）。
    var extraTripsData: Data
    var createdAt: Date

    init(name: String, input: TeikiInput, createdAt: Date = .now) {
        self.name = name
        self.oneWayFare = input.oneWayFare
        self.passPrice = input.passPrice
        self.periodMonths = input.period.months
        self.commuteDaysPerMonth = input.commuteDaysPerMonth
        self.extraTripsData = (try? JSONEncoder().encode(input.extraTrips)) ?? Data()
        self.createdAt = createdAt
    }

    /// 保存内容を計算用の入力へ復元する。
    var input: TeikiInput {
        TeikiInput(
            oneWayFare: oneWayFare,
            passPrice: passPrice,
            period: TeikiPeriod(rawValue: periodMonths) ?? .oneMonth,
            commuteDaysPerMonth: commuteDaysPerMonth,
            extraTrips: (try? JSONDecoder().decode([ExtraTrip].self, from: extraTripsData)) ?? []
        )
    }
}
