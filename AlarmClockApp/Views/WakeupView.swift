import SwiftUI

struct WakeupView: View {
    let alarm: Alarm
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var audioManager: AudioManager
    @State private var isSnoozing = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    Text("Wake up")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)

                    Text(alarm.displayLabel)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))

                    Text(Date(), style: .time)
                        .font(.system(size: 52, weight: .bold))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                }
                .padding()

                HStack(spacing: 16) {
                    Button(action: snooze) {
                        VStack(spacing: 8) {
                            Image(systemName: "pause.circle.fill")
                                .font(.title)
                            Text("Snooze")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                    }

                    Button(action: stop) {
                        VStack(spacing: 8) {
                            Image(systemName: "stop.circle.fill")
                                .font(.title)
                            Text("Stop")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                    }
                }
                .padding()

                Spacer()
            }
        }
        .onAppear {
            audioManager.play(sound: alarm.sound, volume: alarm.volume)
        }
        .onDisappear {
            audioManager.stop()
        }
    }

    private func snooze() {
        isSnoozing = true
        audioManager.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }

    private func stop() {
        audioManager.stop()
        dismiss()
    }
}
