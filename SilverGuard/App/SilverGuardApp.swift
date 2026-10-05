import SwiftUI

@main
struct SilverGuardApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)   // Design is light-mode first
        }
    }
}
