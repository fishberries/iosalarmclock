import SwiftUI

struct WakeupView: View {
    let alarm: Alarm
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Wake up")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                Text(alarm.title)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.9))

                Text(Date(), style: .time)
                    .font(.system(size: 52, weight: .bold))
                    .foregroundStyle(.white)

                HStack(spacing: 16) {
                    Button("Snooze") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundStyle(.blue)

                    Button("Stop") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
        }
    }
}
