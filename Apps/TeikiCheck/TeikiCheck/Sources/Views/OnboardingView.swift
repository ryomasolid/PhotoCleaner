import SwiftUI

/// 初回起動時の説明。アプリの目的を 3 ステップで伝える。
struct OnboardingView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 10) {
                Image(systemName: "tram.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.tint)
                Text("定期チェック")
                    .font(.largeTitle.bold())
                Text("定期券を買うべきか、\nサッと判定できます。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 22) {
                feature("yensign.circle.fill", "運賃を入れるだけ", "片道運賃と定期代を入力すると、元が取れる往復回数がわかります。")
                feature("figure.walk", "元取りラインを判定", "月の通勤日数から、買うべきか都度払いかを判定します。")
                feature("sparkles", "区間内のおでかけも加算", "定期区間内の途中下車や寄り道ぶんも、元取りに足せます。")
            }
            .padding(.horizontal, 8)

            Spacer()

            Button(action: onDone) {
                Text("はじめる")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.tint, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
            }
        }
        .padding(28)
    }

    private func feature(_ icon: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(.tint)
                .frame(width: 44)
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(onDone: {})
}
