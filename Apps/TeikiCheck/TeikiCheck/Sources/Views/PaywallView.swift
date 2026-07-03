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
                    Button {
                        Task { await store.purchase(); if store.isPro { dismiss() } }
                    } label: {
                        Text(store.product == nil ? "購入を準備中…" : "\(store.priceText) で購入")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(store.product == nil ? AnyShapeStyle(.gray) : AnyShapeStyle(.tint), in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.white)
                    }
                    .disabled(store.product == nil)

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
