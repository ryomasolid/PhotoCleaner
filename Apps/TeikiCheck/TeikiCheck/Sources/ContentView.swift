import SwiftData
import SwiftUI

struct ContentView: View {
    @AppStorage("tc.hasSeenOnboarding") private var hasSeenOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @State private var showOnboarding = false
    @State private var selection = 0
    @State private var store = StoreManager()

    var body: some View {
        TabView(selection: $selection) {
            CalculatorView()
                .tabItem { Label("計算", systemImage: "tram.fill") }
                .tag(0)

            HistoryView()
                .tabItem { Label("履歴", systemImage: "clock.arrow.circlepath") }
                .tag(1)
        }
        .environment(store)
        .tint(.accentColor)
        .onAppear {
            // デモ／スクショ用の起動引数を反映する。
            if Launch.isDemo {
                hasSeenOnboarding = true
                Launch.seedHistoryIfNeeded(modelContext)
            }
            if Launch.startTab == "history" { selection = 1 }

            showOnboarding = !hasSeenOnboarding || Launch.forceOnboarding
            // 広告の同意（UMP）→ ATT → AdMob 初期化を実行。
            // 広告非表示（スクショ撮影）時は同意フローも走らせない。
            if !Launch.hideAds {
                ConsentManager.shared.start()
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                hasSeenOnboarding = true
                showOnboarding = false
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: SavedRoute.self, inMemory: true)
}
