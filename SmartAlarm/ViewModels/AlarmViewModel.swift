import Foundation

class AlarmViewModel: ObservableObject {
    @Published var isAlarmActive: Bool = false
    
    func startAlarm(_ alarm: AlarmModel) {
        isAlarmActive = true
        // Jeśli chcesz uruchomić alarm od razu (gdy aplikacja jest aktywna)
        AlarmManager.shared.startAlarm(alarm)
    }
    
    func stopAlarm() {
        isAlarmActive = false
        AlarmManager.shared.stopAlarm()
    }
}
