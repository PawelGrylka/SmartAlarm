import Foundation

struct AlarmModel: Identifiable {
    let id: UUID
    var time: Date
    var isActive: Bool
    var soundFile: String

    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
