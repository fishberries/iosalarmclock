import SwiftUI

struct SleepTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var minutes: Int = 15
    @State private var isRunning = false
    @State private var remaining: TimeInterval = 0
    @State private var timer: Timer? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Sleep Timer")
                    .font(.largeTitle.weight(.bold))

                Text(isRunning ? timeDescription : "Set a timer to fall asleep with music.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Picker("Minutes", selection: $minutes) {
                    ForEach([10, 15, 20, 30, 45, 60], id: \.self) { value in
                        Text("\(value) min").tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Button(action: toggleTimer) {
                    Text(isRunning ? "Stop timer" : "Start timer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Sleep Timer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .onDisappear {
                stopTimer()
            }
        }
    }

    private var timeDescription: String {
        let interval = Int(remaining)
        let minutes = interval / 60
        let seconds = interval % 60
        return String(format: "Remaining %02d:%02d", minutes, seconds)
    }

    private func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    private func startTimer() {
        remaining = TimeInterval(minutes * 60)
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            remaining -= 1
            if remaining <= 0 {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    SleepTimerView()
}
