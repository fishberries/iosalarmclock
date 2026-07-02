import Foundation

enum RepeatOption: String, Codable, CaseIterable, Identifiable {
    case everyDay = "Every day"
    case weekdays = "Weekdays"
    case weekends = "Weekends"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"

    var id: String { rawValue }
    var title: String { rawValue }

    var weekdayNumbers: [Int] {
        switch self {
        case .everyDay:
            return [1, 2, 3, 4, 5, 6, 7]
        case .weekdays:
            return [2, 3, 4, 5, 6]
        case .weekends:
            return [1, 7]
        case .monday:
            return [2]
        case .tuesday:
            return [3]
        case .wednesday:
            return [4]
        case .thursday:
            return [5]
        case .friday:
            return [6]
        case .saturday:
            return [7]
        case .sunday:
            return [1]
        }
    }
}

struct Alarm: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var label: String
    var time: Date
    var enabled: Bool
    var sound: String
    var repeatOptions: [RepeatOption]
    var snoozeMinutes: Int
    var volume: Double
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String = "Alarm",
        label: String = "",
        time: Date = Date(),
        enabled: Bool = true,
        sound: String = "Gentle Chime",
        repeatOptions: [RepeatOption] = [.everyDay],
        snoozeMinutes: Int = 9,
        volume: Double = 0.8,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.label = label
        self.time = time
        self.enabled = enabled
        self.sound = sound
        self.repeatOptions = repeatOptions
        self.snoozeMinutes = snoozeMinutes
        self.volume = volume
        self.createdAt = createdAt
    }

    static let defaultSounds = [
        "Gentle Chime",
        "Ocean Waves",
        "Bright Bell",
        "Soft Piano",
        "Morning Light"
    ]

    var repeatDescription: String {
        if repeatOptions.contains(.everyDay) {
            return RepeatOption.everyDay.title
        }
        if repeatOptions == [.weekdays] {
            return RepeatOption.weekdays.title
        }
        if repeatOptions == [.weekends] {
            return RepeatOption.weekends.title
        }
        return repeatOptions.map(\.title).joined(separator: ", ")
    }

    var displayLabel: String {
        label.isEmpty ? title : label
    }
}
