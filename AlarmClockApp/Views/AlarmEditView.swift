import SwiftUI

struct AlarmEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storage: AlarmStorage
    @State private var title: String
    @State private var time: Date
    @State private var enabled: Bool
    @State private var sound: String
    @State private var repeatDays: [String]
    @State private var snoozeMinutes: Int
    @State private var volume: Double

    private let alarm: Alarm?

    init(storage: AlarmStorage, alarm: Alarm? = nil) {
        self.storage = storage
        self.alarm = alarm
        _title = State(initialValue: alarm?.title ?? "New alarm")
        _time = State(initialValue: alarm?.time ?? Date())
        _enabled = State(initialValue: alarm?.enabled ?? true)
        _sound = State(initialValue: alarm?.sound ?? "Gentle Chime")
        _repeatDays = State(initialValue: alarm?.repeatDays ?? ["Every day"])
        _snoozeMinutes = State(initialValue: alarm?.snoozeMinutes ?? 9)
        _volume = State(initialValue: alarm?.volume ?? 0.8)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Alarm name", text: $title)
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                    Toggle("Enabled", isOn: $enabled)
                }

                Section("Sound") {
                    Picker("Sound", selection: $sound) {
                        Text("Gentle Chime").tag("Gentle Chime")
                        Text("Ocean Waves").tag("Ocean Waves")
                        Text("Bright Bell").tag("Bright Bell")
                        Text("Soft Piano").tag("Soft Piano")
                    }
                    Slider(value: $volume, in: 0.1...1.0, step: 0.1)
                    Text("Volume: \(Int(volume * 100))%")
                }

                Section("Repeat") {
                    ForEach(["Every day", "Weekdays", "Weekends", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                        Toggle(day, isOn: Binding(
                            get: { repeatDays.contains(day) },
                            set: { isOn in
                                if isOn {
                                    if day == "Every day" {
                                        repeatDays = ["Every day"]
                                    } else if !repeatDays.contains(day) {
                                        repeatDays.append(day)
                                    }
                                } else {
                                    repeatDays.removeAll { $0 == day }
                                }
                            }
                        ))
                    }
                }

                Section("Snooze") {
                    Stepper("Snooze \(snoozeMinutes) min", value: $snoozeMinutes, in: 1...20)
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
                            time: time,
                            enabled: enabled,
                            sound: sound,
                            repeatDays: repeatDays,
                            snoozeMinutes: snoozeMinutes,
                            volume: volume
                        )
                        if let alarm {
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
}
