import SwiftUI

struct ContentView: View {
    @StateObject private var storage = AlarmStorage()

    var body: some View {
        AlarmListView(storage: storage)
    }
}

#Preview {
    ContentView()
}
