import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Błąd: \(error.localizedDescription)")
            } else {
                print(granted ? "✅ Powiadomienia dozwolone" : "❌ Powiadomienia zablokowane")
            }
        }

        // Dodajemy kategorię powiadomień
        let alarmCategory = UNNotificationCategory(identifier: "alarmCategory",
                                                   actions: [],
                                                   intentIdentifiers: [],
                                                   options: .customDismissAction)
        center.setNotificationCategories([alarmCategory])
    }

    func scheduleNotification(for alarm: AlarmModel) {
        let content = UNMutableNotificationContent()
        content.title = "⏰ Alarm!"
        content.body = "Czas na alarm!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarmCategory" // <- Pełnoekranowe powiadomienie

        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Błąd planowania powiadomienia: \(error.localizedDescription)")
            } else {
                print("✅ Powiadomienie zaplanowane na \(alarm.time)")
            }
        }
    }
}
