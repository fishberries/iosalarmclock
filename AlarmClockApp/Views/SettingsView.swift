import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var flashlightManager: FlashlightManager
    @State private var showingThemePicker = false
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Notifications enabled", isOn: $notificationsEnabled)
                    Button(action: { showingThemePicker = true }) {
                        HStack {
                            Text("Theme")
                            Spacer()
                            Text(ThemeManager.shared.currentTheme.name)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section("Quick actions") {
                    if flashlightManager.isAvailable {
                        Button(action: {
                            flashlightManager.toggleFlashlight()
                        }) {
                            HStack {
                                Image(systemName: "flashlight.on.fill")
                                Text(flashlightManager.isOn ? "Turn off flashlight" : "Turn on flashlight")
                                Spacer()
                                if flashlightManager.isOn {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("App")
                        Spacer()
                        Text("Alarm Clock Pro")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingThemePicker) {
                ThemePickerView()
            }
        }
    }
}
