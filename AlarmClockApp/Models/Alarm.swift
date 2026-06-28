import Foundation

struct Alarm: Identifiable, Equatable, Codable {
    var id: UUID
    var title: String
    var time: Date
    var enabled: Bool
    var sound: String
    var repeatDays: [String]
    var snoozeMinutes: Int
    var volume: Double

    init(id: UUID = UUID(), title: String, time: Date, enabled: Bool = true, sound: String = "Gentle Chime", repeatDays: [String] = ["Every day"], snoozeMinutes: Int = 9, volume: Double = 0.8) {
        self.id = id
        self.title = title
        self.time = time
        self.enabled = enabled
        self.sound = sound
        self.repeatDays = repeatDays
        self.snoozeMinutes = snoozeMinutes
        self.volume = volume
    }
}
