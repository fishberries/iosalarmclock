import Foundation
import UserNotifications

@MainActor
final class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published private(set) var authorized = false

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        updateAuthorizationStatus()
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.authorized = granted
            }
        }
    }

    func updateAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorized = settings.authorizationStatus == .authorized
            }
        }
    }

    func schedule(alarm: Alarm) {
        cancel(alarm: alarm)

        let content = UNMutableNotificationContent()
        content.title = alarm.title
        content.body = alarm.label.isEmpty ? "Time to wake up" : alarm.label
        content.sound = .default

        let requests = notificationRequests(for: alarm, content: content)
        for request in requests {
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Alarm scheduling failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func cancel(alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIdentifiers(for: alarm))
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func notificationIdentifiers(for alarm: Alarm) -> [String] {
        let weekdays = selectedWeekdays(for: alarm)
        if weekdays.isEmpty {
            return [alarm.id.uuidString]
        }
        return weekdays.map { "\(alarm.id.uuidString)-\($0)" }
    }

    private func notificationRequests(for alarm: Alarm, content: UNNotificationContent) -> [UNNotificationRequest] {
        let weekdays = selectedWeekdays(for: alarm)
        if weekdays.isEmpty {
            let trigger = makeTrigger(for: alarm, weekday: nil)
            return [UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)]
        }
        return weekdays.map { weekday in
            let trigger = makeTrigger(for: alarm, weekday: weekday)
            let identifier = "\(alarm.id.uuidString)-\(weekday)"
            return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        }
    }

    private func selectedWeekdays(for alarm: Alarm) -> [Int] {
        Array(Set(alarm.repeatOptions.flatMap { $0.weekdayNumbers })).sorted()
    }

    private func makeTrigger(for alarm: Alarm, weekday: Int?) -> UNCalendarNotificationTrigger {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.time)
        dateComponents.second = 0

        if let weekday = weekday {
            dateComponents.weekday = weekday
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        }

        let now = Date()
        let next = Calendar.current.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTimePreservingSmallerComponents) ?? alarm.time
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: next)
        return UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
}
