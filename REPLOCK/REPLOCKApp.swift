import SwiftUI

@main
struct REPLOCKApp: App {
    @StateObject private var store = RepLockStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environmentObject(store)
            .preferredColorScheme(.dark)
        }
    }
}
