import Foundation
import AVFoundation

class AlarmManager: ObservableObject {
    static let shared = AlarmManager()
    private var player: AVAudioPlayer?
    
    @Published var activeAlarm: AlarmModel?
    
    /// Zamiast używać asyncAfter, planujemy alarmy poprzez NotificationManager.
    func scheduleAlarms(alarms: [AlarmModel]) {
        cancelExistingTimers()
        for alarm in alarms where alarm.isActive {
            NotificationManager.shared.scheduleNotification(for: alarm)
        }
    }
    
    /// Opcjonalnie – gdy aplikacja jest aktywna, możesz wywołać tę metodę, aby rozpocząć alarm wewnątrz aplikacji.
    func startAlarm(_ alarm: AlarmModel) {
        activeAlarm = alarm
        playSound(named: alarm.soundFile)
        print("🚨 Alarm aktywowany o \(Date()) dla \(alarm.time)!")
    }
    
    func stopAlarm() {
        player?.stop()
        activeAlarm = nil
    }
    
    func playSound(named soundFile: String) {
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else {
            print("❌ Nie znaleziono pliku: \(soundFile)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1  // Odtwarzanie w pętli
            player?.play()
        } catch {
            print("❌ Błąd odtwarzania dźwięku: \(error.localizedDescription)")
        }
    }
    
    private func cancelExistingTimers() {
        player?.stop()
    }
    
    // Opcjonalnie – funkcja pomocnicza, jeśli chcesz obliczać interwał czasowy do alarmu.
    private func timeUntil(_ alarmTime: Date) -> TimeInterval {
        let now = Date()
        let calendar = Calendar.current
        let alarmComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        let todayAlarm = calendar.date(bySettingHour: alarmComponents.hour!,
                                       minute: alarmComponents.minute!,
                                       second: 0,
                                       of: now)
        let finalAlarmTime = (todayAlarm ?? now) < now ? calendar.date(byAdding: .day, value: 1, to: todayAlarm!)! : todayAlarm!
        let interval = finalAlarmTime.timeIntervalSince(now)
        print("📊 Czas do alarmu: \(interval) sekund (finalna godzina: \(finalAlarmTime))")
        return interval
    }
}
