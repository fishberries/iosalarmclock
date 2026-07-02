import SwiftUI

@main
struct AlarmClockAppApp: App {
    @StateObject private var storage = AlarmStorage()
    @StateObject private var notificationManager = NotificationManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var weatherManager = WeatherManager.shared
    @StateObject private var flashlightManager = FlashlightManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView(storage: storage)
                .environmentObject(notificationManager)
                .environmentObject(audioManager)
                .environmentObject(themeManager)
                .environmentObject(weatherManager)
                .environmentObject(flashlightManager)
                .onAppear {
                    notificationManager.requestAuthorization()
                }
        }
    }
}
