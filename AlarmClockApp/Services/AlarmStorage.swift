import Foundation

@MainActor
final class AlarmStorage: ObservableObject {
    @Published var alarms: [Alarm] = []

    private let storageKey = "alarms"

    init() {
        load()
    }

    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
        save()
    }

    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            save()
        }
    }

    func deleteAlarm(id: UUID) {
        alarms.removeAll { $0.id == id }
        save()
    }

    func toggleAlarm(id: UUID, enabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == id }) {
            alarms[index].enabled = enabled
            save()
        }
    }

    private func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(alarms) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            alarms = [
                Alarm(title: "Wake up", time: defaultDate(hour: 7, minute: 0), enabled: true, sound: "Ocean Waves"),
                Alarm(title: "Gym", time: defaultDate(hour: 6, minute: 30), enabled: false, sound: "Bright Bell")
            ]
            return
        }

        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Alarm].self, from: data) {
            alarms = decoded
        }
    }

    private func defaultDate(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        components.second = 0
        return calendar.date(from: components) ?? Date()
    }
}
