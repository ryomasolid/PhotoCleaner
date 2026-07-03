import SwiftUI

/// Pro へのアップグレード画面。買い切りで広告非表示＋今後の追加機能。
struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(StoreManager.self) private var store

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "crown.fill")
                .font(.system(size: 56))
                .foregroundStyle(.yellow)
            Text("定期チェック Pro")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 18) {
                benefit("rectangle.slash", "広告を非表示", "すっきり快適に")
                benefit("bookmark.fill", "区間の保存も快適に", "履歴を気持ちよく使える")
                benefit("infinity", "今後の追加機能", "アップデートで増える機能もすべて")
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                if store.isPro {
                    Label("購入済みです。ありがとうございます！", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else {
                    // スクショ用のデモ時は、商品未ロードでもサンプル価格を表示する。
                    let ready = store.product != nil || Launch.isDemo
                    let priceLabel = store.product != nil ? "\(store.priceText) で購入"
                        : (Launch.isDemo ? "¥300 で購入" : "購入を準備中…")
                    Button {
                        Task { await store.purchase(); if store.isPro { dismiss() } }
                    } label: {
                        Text(priceLabel)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ready ? AnyShapeStyle(.tint) : AnyShapeStyle(.gray), in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.white)
                    }
                    .disabled(!ready)

                    Button("購入を復元") {
                        Task { await store.restore(); if store.isPro { dismiss() } }
                    }
                    .font(.subheadline)
                }
            }
            .padding(.horizontal)

            Button("閉じる") { dismiss() }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.bottom)
        }
    }

    private func benefit(_ icon: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}
