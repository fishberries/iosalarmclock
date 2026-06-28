import SwiftUI

struct AlarmListView: View {
    @ObservedObject var storage: AlarmStorage
    @State private var showingEditor = false
    @State private var editingAlarm: Alarm?
    @State private var showingWakeup = false
    @State private var activeAlarm: Alarm?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.18), Color.purple.opacity(0.12)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Good morning")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(Date(), style: .date)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Text("Wake up your way")
                            .font(.title.bold())
                    }
                    .padding(.horizontal)

                    List {
                        ForEach(storage.alarms) { alarm in
                            Button {
                                editingAlarm = alarm
                                showingEditor = true
                            } label: {
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(alarm.title)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Text(alarm.sound)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text(alarm.repeatDays.joined(separator: ", "))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 6) {
                                        Text(alarm.time, style: .time)
                                            .font(.title2.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        Toggle("", isOn: Binding(get: { alarm.enabled }, set: { newValue in
                                            storage.toggleAlarm(id: alarm.id, enabled: newValue)
                                        }))
                                        .labelsHidden()
                                    }
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)

                    VStack(spacing: 12) {
                        Button {
                            editingAlarm = nil
                            showingEditor = true
                        } label: {
                            Label("Add alarm", systemImage: "plus.circle.fill")
                                .font(.headline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.15))
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        HStack(spacing: 12) {
                            Label("Music or sounds", systemImage: "speaker.wave.2")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Label("Sleep timer", systemImage: "moon.zzz")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("Alarm Clock")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings") {
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                AlarmEditView(storage: storage, alarm: editingAlarm)
            }
            .sheet(isPresented: $showingWakeup) {
                if let activeAlarm {
                    WakeupView(alarm: activeAlarm)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = storage.alarms[index]
            storage.deleteAlarm(id: alarm.id)
        }
    }
}
