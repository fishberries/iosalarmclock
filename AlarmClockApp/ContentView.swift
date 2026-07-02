import SwiftUI

struct ContentView: View {
    @ObservedObject var storage: AlarmStorage

    var body: some View {
        TabView {
            AlarmListView(storage: storage)
                .tabItem {
                    Label("Alarms", systemImage: "alarm")
                }

            NightstandandView(storage: storage)
                .tabItem {
                    Label("Nightstand", systemImage: "moon")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    ContentView(storage: AlarmStorage())
}
