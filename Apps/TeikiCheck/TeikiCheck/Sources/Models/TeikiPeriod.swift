import Foundation

/// 定期券の有効期間。App Store でよく使われる 1／3／6 ヶ月に対応する。
enum TeikiPeriod: Int, CaseIterable, Identifiable, Codable {
    case oneMonth = 1
    case threeMonths = 3
    case sixMonths = 6

    var id: Int { rawValue }

    /// 有効月数。
    var months: Int { rawValue }

    /// セグメント表示などに使う短いラベル。
    var label: String {
        switch self {
        case .oneMonth: "1ヶ月"
        case .threeMonths: "3ヶ月"
        case .sixMonths: "6ヶ月"
        }
    }
}
