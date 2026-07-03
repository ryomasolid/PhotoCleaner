import SwiftUI

/// アプリ共通の見た目・整形ヘルパー。
enum Theme {
    /// 円の整形（3 桁区切り＋「円」）。
    static func yen(_ value: Int) -> String {
        let formatted = Self.decimal(abs(value))
        return value < 0 ? "-\(formatted)円" : "\(formatted)円"
    }

    /// 3 桁区切りの数値文字列。
    static func decimal(_ value: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

/// カード状の背景 modifier。
private struct CardBackground: ViewModifier {
    var padding: CGFloat = 18
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func cardStyle(padding: CGFloat = 18) -> some View {
        modifier(CardBackground(padding: padding))
    }
}
