import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let condition: String
    let icon: String
}

@MainActor
final class WeatherManager: ObservableObject {
    static let shared = WeatherManager()
    @Published var weather: WeatherData? = nil
    @Published var isLoading = false

    func fetchWeather() {
        isLoading = true
        weather = WeatherData(temperature: 72, condition: "Partly Cloudy", icon: "⛅")
        isLoading = false
    }
}
