import SwiftUI

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var currentTheme: AppTheme = .default
    @Published var accentColor: Color = .blue

    private let themeKey = "selectedTheme"

    init() {
        load()
    }

    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
        accentColor = theme.accentColor
        save()
    }

    private func save() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
    }

    private func load() {
        if let saved = UserDefaults.standard.string(forKey: themeKey),
           let theme = AppTheme(rawValue: saved) {
            currentTheme = theme
            accentColor = theme.accentColor
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case `default` = "default"
    case ocean = "ocean"
    case sunset = "sunset"
    case forest = "forest"
    case midnight = "midnight"

    var id: String { rawValue }
    var name: String {
        switch self {
        case .default: return "Blue"
        case .ocean: return "Ocean"
        case .sunset: return "Sunset"
        case .forest: return "Forest"
        case .midnight: return "Midnight"
        }
    }

    var accentColor: Color {
        switch self {
        case .default: return .blue
        case .ocean: return Color(red: 0.0, green: 0.48, blue: 0.8)
        case .sunset: return Color(red: 1.0, green: 0.55, blue: 0.0)
        case .forest: return Color(red: 0.2, green: 0.6, blue: 0.3)
        case .midnight: return Color(red: 0.2, green: 0.2, blue: 0.4)
        }
    }

    var gradientStart: Color {
        accentColor.opacity(0.3)
    }

    var gradientEnd: Color {
        Color.purple.opacity(0.15)
    }
}
