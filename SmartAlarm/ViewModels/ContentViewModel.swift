import Foundation

class ContentViewModel: ObservableObject {
    @Published var alarms: [AlarmModel] = [] {
        didSet {
            // Każdorazowo, gdy lista alarmów ulegnie zmianie, przeliczamy/zapraszamy alarmy.
            AlarmManager.shared.scheduleAlarms(alarms: alarms)
        }
    }
    
    func addAlarm(_ newAlarm: AlarmModel) {
        alarms.append(newAlarm)
    }
    
    func updateAlarm(_ updatedAlarm: AlarmModel) {
        if let index = alarms.firstIndex(where: { $0.id == updatedAlarm.id }) {
            alarms[index] = updatedAlarm
        }
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
    
    func toggleAlarmState(_ alarm: AlarmModel) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isActive.toggle()
        }
    }
}
