import SwiftUI

struct AlarmEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storage: AlarmStorage
    @State private var title: String
    @State private var label: String
    @State private var time: Date
    @State private var enabled: Bool
    @State private var sound: String
    @State private var repeatOptions: [RepeatOption]
    @State private var snoozeMinutes: Int
    @State private var volume: Double

    private let alarm: Alarm?

    init(storage: AlarmStorage, alarm: Alarm? = nil) {
        self.storage = storage
        self.alarm = alarm
        _title = State(initialValue: alarm?.title ?? "Morning Alarm")
        _label = State(initialValue: alarm?.label ?? "")
        _time = State(initialValue: alarm?.time ?? Date())
        _enabled = State(initialValue: alarm?.enabled ?? true)
        _sound = State(initialValue: alarm?.sound ?? Alarm.defaultSounds.first!)
        _repeatOptions = State(initialValue: alarm?.repeatOptions ?? [.everyDay])
        _snoozeMinutes = State(initialValue: alarm?.snoozeMinutes ?? 9)
        _volume = State(initialValue: alarm?.volume ?? 0.8)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Alarm details") {
                    TextField("Alarm name", text: $title)
                    TextField("Label (optional)", text: $label)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    Toggle("Enabled", isOn: $enabled)
                }

                Section("Sound") {
                    Picker("Sound", selection: $sound) {
                        ForEach(Alarm.defaultSounds, id: \.self) { sound in
                            Text(sound).tag(sound)
                        }
                    }
                    Slider(value: $volume, in: 0.1...1.0, step: 0.1)
                    Text("Playback volume: \(Int(volume * 100))%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Section("Repeat") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(RepeatOption.allCases) { option in
                            Toggle(option.title, isOn: Binding(
                                get: { repeatOptions.contains(option) },
                                set: { isOn in
                                    if isOn {
                                        addRepeatOption(option)
                                    } else {
                                        repeatOptions.removeAll { $0 == option }
                                    }
                                }
                            ))
                        }
                    }
                }

                Section("Snooze") {
                    Stepper("Snooze \(snoozeMinutes) min", value: $snoozeMinutes, in: 1...30)
                }
            }
            .navigationTitle(alarm == nil ? "New alarm" : "Edit alarm")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newAlarm = Alarm(
                            id: alarm?.id ?? UUID(),
                            title: title.isEmpty ? "Alarm" : title,
                            label: label,
                            time: time,
                            enabled: enabled,
                            sound: sound,
                            repeatOptions: repeatOptions.isEmpty ? [.everyDay] : repeatOptions,
                            snoozeMinutes: snoozeMinutes,
                            volume: volume
                        )
                        if let _ = alarm {
                            storage.updateAlarm(newAlarm)
                        } else {
                            storage.addAlarm(newAlarm)
                        }
                        dismiss()
                    }
                }
            }
        }
    }

    private func addRepeatOption(_ option: RepeatOption) {
        if option == .everyDay {
            repeatOptions = [.everyDay]
            return
        }
        repeatOptions.removeAll(where: { $0 == .everyDay })
        if !repeatOptions.contains(option) {
            repeatOptions.append(option)
        }
    }
}
