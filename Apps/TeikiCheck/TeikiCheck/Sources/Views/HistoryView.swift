import SwiftData
import SwiftUI

/// 保存した区間の一覧。タップで結果を見返せる。
struct HistoryView: View {
    @Query(sort: \SavedRoute.createdAt, order: .reverse) private var routes: [SavedRoute]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Group {
                if routes.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(routes) { route in
                            NavigationLink {
                                SavedRouteDetailView(route: route)
                            } label: {
                                row(route)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("履歴")
        }
    }

    private func row(_ route: SavedRoute) -> some View {
        let result = TeikiCalculator.calculate(route.input)
        return VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(route.name)
                    .font(.headline)
                Spacer()
                Text(result.verdict.title)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(verdictColor(result.verdict).opacity(0.15), in: Capsule())
                    .foregroundStyle(verdictColor(result.verdict))
            }
            Text("片道\(Theme.yen(route.oneWayFare))・定期\(Theme.yen(route.passPrice))（\(route.periodMonths)ヶ月）")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("履歴はまだありません", systemImage: "clock.arrow.circlepath")
        } description: {
            Text("計算タブで区間を保存すると、ここに表示されます。")
        }
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets { modelContext.delete(routes[index]) }
        try? modelContext.save()
    }

    private func verdictColor(_ v: TeikiCalculator.Verdict) -> Color {
        switch v {
        case .worthBuying: .green
        case .breakEven: .orange
        case .notWorth: .red
        }
    }
}

/// 履歴の詳細（保存時の入力から結果を再計算して表示）。
struct SavedRouteDetailView: View {
    let route: SavedRoute

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ResultCardView(input: route.input, result: TeikiCalculator.calculate(route.input))
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(route.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
