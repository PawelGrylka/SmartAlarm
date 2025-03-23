import SwiftUI
import UserNotifications

@main
struct SmartAlarm: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var contentViewModel = ContentViewModel()

    init() {
        NotificationManager.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentViewModel)
        }
    }
}
