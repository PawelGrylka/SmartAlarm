import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var showingEditAlarmView = false
    @State private var selectedAlarm: AlarmModel?
    @State private var showAlarmChallenge = false  // Dodajemy stan do obsługi AlarmChallengeView

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.alarms, id: \.id) { alarm in
                        alarmRow(for: alarm)
                    }
                    .onDelete(perform: viewModel.deleteAlarm)
                }
                .navigationTitle("Budzik")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            selectedAlarm = nil
                            showingEditAlarmView = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }

                Button("Testuj Alarm") {
                    let testAlarm = AlarmModel(id: UUID(), time: Date().addingTimeInterval(5), isActive: true, soundFile: "alarmSound")
                    print("🛠️ Tworzę testowy alarm na \(testAlarm.time)") // 🔍 Debug
                    AlarmManager.shared.scheduleAlarms(alarms: [testAlarm])
                }
            }
            .onAppear {
                NotificationManager.shared.requestPermission()
                NotificationCenter.default.addObserver(forName: NSNotification.Name("ShowAlarmChallengeView"), object: nil, queue: .main) { _ in
                    showAlarmChallenge = true  // Odbieramy powiadomienie i ustawiamy stan
                }
            }
            .fullScreenCover(isPresented: $showAlarmChallenge) {
                AlarmChallengeView()  // Prezentujemy AlarmChallengeView, gdy stan showAlarmChallenge jest true
            }
            .sheet(isPresented: $showingEditAlarmView) {
                if let selectedAlarm = selectedAlarm {
                    EditAlarmView(alarm: selectedAlarm, viewModel: viewModel)
                } else {
                    EditAlarmView(alarm: nil, viewModel: viewModel)
                }
            }
        }
    }

    private func alarmRow(for alarm: AlarmModel) -> some View {
        HStack {
            Button(action: {
                selectedAlarm = alarm
                showingEditAlarmView = true
            }) {
                VStack(alignment: .leading) {
                    Text(alarm.timeFormatted)
                        .font(.title2)
                        .bold()
                    Text(alarm.isActive ? "Aktywny" : "Nieaktywny")
                        .font(.subheadline)
                        .foregroundColor(alarm.isActive ? .green : .red)
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(PlainButtonStyle()) // Usuwa domyślny efekt przycisku

            Spacer()

            Toggle("", isOn: Binding(
                get: { alarm.isActive },
                set: { newValue in
                    viewModel.toggleAlarmState(alarm)
                }
            ))
            .labelsHidden()
        }
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
