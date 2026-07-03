import Testing
@testable import TeikiCheck

struct TeikiCalculatorTests {

    @Test func breakEvenRoundTripsRoundsUp() {
        // 定期 10000 円 / 片道 200 円（往復 400 円）→ 25 往復でちょうど。
        let input = TeikiInput(oneWayFare: 200, passPrice: 10000, period: .oneMonth, commuteDaysPerMonth: 0)
        let result = TeikiCalculator.calculate(input)
        #expect(result.breakEvenRoundTrips == 25)
        #expect(result.breakEvenDaysPerMonth == 25)
    }

    @Test func breakEvenRoundTripsCeil() {
        // 10100 / 400 = 25.25 → 26 往復。
        let input = TeikiInput(oneWayFare: 200, passPrice: 10100)
        #expect(TeikiCalculator.calculate(input).breakEvenRoundTrips == 26)
    }

    @Test func worthBuyingWhenCommutingEnough() {
        // 月 20 日通勤 × 往復 400 円 = 8000 円 > 定期 6000 円 → 買うべき。
        let input = TeikiInput(oneWayFare: 200, passPrice: 6000, period: .oneMonth, commuteDaysPerMonth: 20)
        let result = TeikiCalculator.calculate(input)
        #expect(result.verdict == .worthBuying)
        #expect(result.totalSavings == 2000)
        #expect(result.remainingRoundTrips == 0)
    }

    @Test func notWorthWhenSeldomCommuting() {
        // 月 5 日 → 往復 5 × 400 = 2000 円 < 定期 6000 円 → 都度払い。
        let input = TeikiInput(oneWayFare: 200, passPrice: 6000, period: .oneMonth, commuteDaysPerMonth: 5)
        let result = TeikiCalculator.calculate(input)
        #expect(result.verdict == .notWorth)
        #expect(result.totalSavings == -4000)
        // あと 10 往復（15 - 5）で元が取れる。
        #expect(result.remainingRoundTrips == 10)
    }

    @Test func extraTripsCountTowardBreakEven() {
        // 通勤だけでは赤字だが、区間内利用で黒字化する。
        var input = TeikiInput(oneWayFare: 200, passPrice: 6000, period: .oneMonth, commuteDaysPerMonth: 10)
        // 通勤: 10 往復 × 400 = 4000 円（定期 6000 円に 2000 円足りない）。
        input.extraTrips = [ExtraTrip(name: "買い物", oneWayFare: 300, isRoundTrip: true, timesPerMonth: 5)]
        // 追加: 300×2×5 = 3000 円/月。合計 7000 円 > 6000 円。
        let result = TeikiCalculator.calculate(input)
        #expect(result.extraSavings == 3000)
        #expect(result.totalSavings == 1000)
        #expect(result.verdict == .worthBuying)
        // 実質ライン: (6000 - 3000) / 400 = 7.5 → 8 往復。通勤 10 往復で足りている。
        #expect(result.effectiveBreakEvenRoundTrips == 8)
        #expect(result.remainingRoundTrips == 0)
    }

    @Test func sixMonthPassScalesPlannedTrips() {
        // 6 ヶ月定期。月 20 日 × 6 = 120 往復。
        let input = TeikiInput(oneWayFare: 200, passPrice: 40000, period: .sixMonths, commuteDaysPerMonth: 20)
        let result = TeikiCalculator.calculate(input)
        #expect(result.plannedRoundTrips == 120)
        // 120 × 400 = 48000 円 - 40000 円 = 8000 円お得。
        #expect(result.totalSavings == 8000)
    }

    @Test func breakEvenVerdictNearZero() {
        // ちょうどトントン（差 0）。
        let input = TeikiInput(oneWayFare: 200, passPrice: 8000, period: .oneMonth, commuteDaysPerMonth: 20)
        let result = TeikiCalculator.calculate(input)
        #expect(result.totalSavings == 0)
        #expect(result.verdict == .breakEven)
    }
}
