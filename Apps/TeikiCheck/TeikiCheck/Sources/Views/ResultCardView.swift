import SwiftUI

/// 計算結果のメイン表示。判定バッジ＋損益分岐往復数＋損益額をまとめて見せる。
struct ResultCardView: View {
    let input: TeikiInput
    let result: TeikiCalculator.Result

    private var accent: Color {
        switch result.verdict {
        case .worthBuying: .green
        case .breakEven: .orange
        case .notWorth: .red
        }
    }

    private var hasExtras: Bool { result.extraSavings > 0 }

    var body: some View {
        VStack(spacing: 16) {
            verdictHeader

            Divider()

            // 損益分岐の往復回数（このアプリの主役の数字）。
            breakEvenBlock

            Divider()

            // 今の通勤ペースでの損益。
            savingsBlock

            if hasExtras {
                Divider()
                extraBlock
            }
        }
        .cardStyle()
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(accent.opacity(0.35), lineWidth: 1)
        )
    }

    private var verdictHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: result.verdict.systemImage)
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background(
                    LinearGradient(colors: [accent, accent.opacity(0.7)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(result.verdict.title)
                    .font(.title3.bold())
                Text(headline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private var headline: String {
        switch result.verdict {
        case .worthBuying: "この使い方なら定期がお得です"
        case .breakEven: "どちらでも大きな差はありません"
        case .notWorth: "都度払いの方が安く済みます"
        }
    }

    private var breakEvenBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("元が取れる往復回数")
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(result.breakEvenRoundTrips)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(accent)
                Text("往復")
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
            }
            Text("月に約 \(result.breakEvenDaysPerMonth) 日の通勤で元が取れます")
                .font(.footnote)
                .foregroundStyle(.secondary)

            if result.remainingRoundTrips > 0 {
                Label("いまの入力だと、あと \(result.remainingRoundTrips) 往復で元が取れます",
                      systemImage: "figure.walk")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(accent)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var savingsBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            statRow(label: "\(input.period.label)トータルの損益",
                    value: Theme.yen(result.totalSavings),
                    valueColor: result.totalSavings >= 0 ? .green : .red)
            statRow(label: "想定の通勤往復（\(input.commuteDaysPerMonth)日/月 × \(input.period.months)ヶ月）",
                    value: "\(result.plannedRoundTrips)往復",
                    valueColor: .primary)
        }
    }

    private var extraBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("定期区間内の追加利用ぶん", systemImage: "sparkles")
                .font(.caption)
                .foregroundStyle(.secondary)
            statRow(label: "浮いた運賃（\(input.period.label)ぶん）",
                    value: Theme.yen(result.extraSavings),
                    valueColor: .green)
            if result.commuteOnlySavings < 0, result.totalSavings >= 0 {
                Text("通勤だけなら赤字ですが、区間内のおでかけを足すと元が取れます。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func statRow(label: String, value: String, valueColor: Color) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(valueColor)
        }
    }
}
