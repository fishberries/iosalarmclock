import SwiftUI

struct AlarmListView: View {
    @ObservedObject var storage: AlarmStorage
    @State private var showingEditor = false
    @State private var editingAlarm: Alarm?
    @State private var editMode = EditMode.inactive

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.20), Color.purple.opacity(0.10)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    header

                    List {
                        ForEach(storage.alarms) { alarm in
                            Button {
                                editingAlarm = alarm
                                showingEditor = true
                            } label: {
                                alarmRow(alarm)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)

                    bottomActions
                }
                .padding(.bottom, 8)
            }
            .navigationTitle("Alarm Clock")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editingAlarm = nil
                        showingEditor = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $showingEditor) {
                AlarmEditView(storage: storage, alarm: editingAlarm)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Good morning")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(Date(), style: .date)
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Wake up your way")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)

            Capsule()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 62, height: 5)
        }
        .padding(.horizontal)
    }

    private func alarmRow(_ alarm: Alarm) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(alarm.displayLabel)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(alarm.repeatDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(alarm.sound)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(alarm.time, style: .time)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                Toggle("", isOn: Binding(
                    get: { alarm.enabled },
                    set: { newValue in
                        storage.toggleAlarm(id: alarm.id, enabled: newValue)
                    }
                ))
                .labelsHidden()
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
    }

    private var bottomActions: some View {
        VStack(spacing: 12) {
            Button {
                editingAlarm = nil
                showingEditor = true
            } label: {
                Label("Create new alarm", systemImage: "plus.circle.fill")
                    .font(.headline.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            HStack(spacing: 12) {
                infoCard(systemName: "speaker.wave.2", title: "Sound library")
                NavigationLink(destination: SleepTimerView()) {
                    infoCard(systemName: "moon.zzz", title: "Sleep timer")
                }
            }
            .padding(.horizontal)
        }
    }

    private func infoCard(systemName: String, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemName)
                .font(.title3)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(10)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.95))
        .cornerRadius(16)
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let alarm = storage.alarms[index]
            storage.deleteAlarm(id: alarm.id)
        }
    }
}
