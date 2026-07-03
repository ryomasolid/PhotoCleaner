import Foundation

/// 定期券の損益判定。純粋関数だけで構成し、単体テストしやすくしている。
enum TeikiCalculator {

    /// 損益の総合判定。
    enum Verdict {
        /// 今の使い方なら定期を買った方がお得。
        case worthBuying
        /// ほぼトントン（数%以内）。
        case breakEven
        /// 都度払いの方がお得。
        case notWorth

        var title: String {
            switch self {
            case .worthBuying: "定期を買うべき！"
            case .breakEven: "ほぼトントン"
            case .notWorth: "都度払いがお得"
            }
        }

        var systemImage: String {
            switch self {
            case .worthBuying: "checkmark.seal.fill"
            case .breakEven: "equal.circle.fill"
            case .notWorth: "xmark.seal.fill"
            }
        }
    }

    /// 計算結果一式。
    struct Result: Equatable {
        /// 通勤だけで定期がペイする「往復回数」。
        var breakEvenRoundTrips: Int
        /// 通勤だけで定期がペイするのに必要な「1 ヶ月あたりの通勤日数」。
        var breakEvenDaysPerMonth: Int
        /// 期間中に実際に通う想定往復数（通勤日数 × 月数）。
        var plannedRoundTrips: Int
        /// 通勤だけで見たときの期間トータルの損益（プラスなら得、円）。
        var commuteOnlySavings: Int
        /// 追加利用（定期区間内）で期間中に浮く運賃合計（円）。
        var extraSavings: Int
        /// 追加利用も含めた期間トータルの損益（円）。
        var totalSavings: Int
        /// 総合判定（追加利用も加味）。
        var verdict: Verdict
        /// あと何往復で元が取れるか（現状ペースで足りない場合の残り。足りていれば 0）。
        var remainingRoundTrips: Int
        /// 損益分岐に達するのに、追加利用を除いて必要な通勤往復数（区間内利用ぶんを差し引いた実質ライン）。
        var effectiveBreakEvenRoundTrips: Int
    }

    /// 端数を切り上げる整数割り算（a / b）。b<=0 のときは 0。
    private static func ceilDiv(_ a: Int, _ b: Int) -> Int {
        guard b > 0 else { return 0 }
        return (a + b - 1) / b
    }

    /// 入力から結果を計算する。
    static func calculate(_ input: TeikiInput) -> Result {
        let months = max(1, input.period.months)
        let fare = max(0, input.oneWayFare)
        let pass = max(0, input.passPrice)
        let days = max(0, input.commuteDaysPerMonth)

        let roundTripFare = fare * 2

        // 定期がペイする往復数（通勤のみ）。
        let breakEvenRoundTrips = ceilDiv(pass, roundTripFare)
        let breakEvenDaysPerMonth = ceilDiv(breakEvenRoundTrips, months)

        // 実際に通う想定往復数。
        let plannedRoundTrips = days * months

        // 通勤だけで見た損益。
        let commuteRegularCost = plannedRoundTrips * roundTripFare
        let commuteOnlySavings = commuteRegularCost - pass

        // 追加利用（区間内）で期間中に浮く運賃。
        let extraSavings = input.extraTrips.reduce(0) { $0 + $1.monthlyValue } * months

        // 追加利用も含めた損益。
        let totalSavings = commuteRegularCost + extraSavings - pass

        // 追加利用ぶんを定期代から差し引いた「実質の元取りライン」。
        let remainingPassAfterExtra = max(0, pass - extraSavings)
        let effectiveBreakEvenRoundTrips = ceilDiv(remainingPassAfterExtra, roundTripFare)
        let remainingRoundTrips = max(0, effectiveBreakEvenRoundTrips - plannedRoundTrips)

        // 判定は「トータル損益」を基準に、定期代に対する割合で丸める。
        let verdict: Verdict
        if pass > 0, abs(totalSavings) * 100 <= pass * 3 {
            verdict = .breakEven
        } else if totalSavings > 0 {
            verdict = .worthBuying
        } else {
            verdict = .notWorth
        }

        return Result(
            breakEvenRoundTrips: breakEvenRoundTrips,
            breakEvenDaysPerMonth: breakEvenDaysPerMonth,
            plannedRoundTrips: plannedRoundTrips,
            commuteOnlySavings: commuteOnlySavings,
            extraSavings: extraSavings,
            totalSavings: totalSavings,
            verdict: verdict,
            remainingRoundTrips: remainingRoundTrips,
            effectiveBreakEvenRoundTrips: effectiveBreakEvenRoundTrips
        )
    }
}
