import SwiftUI

struct ContentView: View {
    @AppStorage("tc.hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showOnboarding = false
    @State private var store = StoreManager()

    var body: some View {
        TabView {
            CalculatorView()
                .tabItem { Label("計算", systemImage: "tram.fill") }

            HistoryView()
                .tabItem { Label("履歴", systemImage: "clock.arrow.circlepath") }
        }
        .environment(store)
        .tint(.accentColor)
        .onAppear {
            showOnboarding = !hasSeenOnboarding
            // 広告の同意（UMP）→ ATT → AdMob 初期化を実行。
            ConsentManager.shared.start()
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
}
