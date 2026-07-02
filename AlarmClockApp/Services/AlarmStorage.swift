import Foundation

@MainActor
final class AlarmStorage: ObservableObject {
    @Published var alarms: [Alarm] = []

    private let storageKey = "alarms"

    init() {
        load()
        refreshNotifications()
    }

    func addAlarm(_ alarm: Alarm) {
        alarms.append(alarm)
        save()
        refreshNotifications()
    }

    func updateAlarm(_ alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            save()
            refreshNotifications()
        }
    }

    func deleteAlarm(id: UUID) {
        if let alarm = alarms.first(where: { $0.id == id }) {
            NotificationManager.shared.cancel(alarm: alarm)
        }
        alarms.removeAll { $0.id == id }
        save()
    }

    func toggleAlarm(id: UUID, enabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == id }) {
            alarms[index].enabled = enabled
            save()
            refreshNotifications()
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
                Alarm(title: "Morning", label: "Start the day", time: defaultDate(hour: 7, minute: 0), enabled: true, sound: "Ocean Waves", repeatOptions: [.weekdays]),
                Alarm(title: "Workout", label: "Gym session", time: defaultDate(hour: 6, minute: 30), enabled: false, sound: "Bright Bell", repeatOptions: [.weekdays])
            ]
            return
        }

        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Alarm].self, from: data) {
            alarms = decoded
        } else {
            alarms = []
        }
    }

    private func refreshNotifications() {
        NotificationManager.shared.cancelAll()
        for alarm in alarms where alarm.enabled {
            NotificationManager.shared.schedule(alarm: alarm)
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
