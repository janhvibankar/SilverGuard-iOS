import SwiftUI
#if canImport(FirebaseCore)
import FirebaseCore
#endif

// MARK: - App Delegate for Firebase Initialization
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if canImport(FirebaseCore)
        FirebaseApp.configure()
        #endif
        return true
    }
}

@main
struct SilverGuardApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)   // Design is light-mode first
        }
    }
}
