import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        return true
    }
    
    // Powiadomienie pojawia się, gdy aplikacja jest aktywna
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let activeAlarm = AlarmManager.shared.activeAlarm {
            AlarmManager.shared.startAlarm(activeAlarm) // Teraz przekazujemy alarm
        }
        
        completionHandler([.banner, .sound])
    }
    
    // Powiadomienie zostało kliknięte – otwieramy AlarmChallengeView
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("ShowAlarmChallengeView"), object: nil)
        }
        
        completionHandler()
    }
}
