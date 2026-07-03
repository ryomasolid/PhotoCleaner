import SwiftData
import SwiftUI

@main
struct TeikiCheckApp: App {
    /// 履歴（保存した区間）の永続化に SwiftData を使う。
    let modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: SavedRoute.self)
        } catch {
            fatalError("SwiftData の初期化に失敗しました: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
