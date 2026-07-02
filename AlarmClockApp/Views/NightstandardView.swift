import SwiftUI

struct NightstandandView: View {
    @ObservedObject var storage: AlarmStorage
    @ObservedObject var theme = ThemeManager.shared
    @ObservedObject var weather = WeatherManager.shared
    @State private var updateTimer: Timer? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [theme.currentTheme.gradientStart, theme.currentTheme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(Date(), style: .time)
                        .font(.system(size: 72, weight: .thin, design: .default))
                        .monospacedDigit()
                        .foregroundColor(.white)
                    Text(Date(), style: .date)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()

                Divider()
                    .opacity(0.3)

                if let weather = weather.weather {
                    HStack(spacing: 16) {
                        Text(weather.icon)
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text(weather.condition)
                                .font(.headline)
                            Text(String(format: "%.0f°C", weather.temperature))
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(16)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Next Alarms")
                        .font(.headline)
                        .foregroundColor(.white)
                    ForEach(storage.alarms.filter({ $0.enabled }).prefix(2)) { alarm in
                        HStack {
                            Text(alarm.time, style: .time)
                                .font(.title3.weight(.semibold))
                            Text(alarm.displayLabel)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            startClockUpdate()
            weather.fetchWeather()
        }
        .onDisappear {
            updateTimer?.invalidate()
        }
    }

    private func startClockUpdate() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
