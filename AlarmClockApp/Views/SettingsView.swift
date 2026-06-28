import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section("Preferences") {
                Toggle("Notifications", isOn: .constant(true))
                Toggle("Nightstand mode", isOn: .constant(true))
                Toggle("Flashlight shortcut", isOn: .constant(true))
            }

            Section("About") {
                Text("Alarm Clock App")
                Text("Version 1.0")
                Text("Built for GitHub Actions CI")
            }
        }
        .navigationTitle("Settings")
    }
}
