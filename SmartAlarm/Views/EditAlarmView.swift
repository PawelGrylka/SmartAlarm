import SwiftUI
import MediaPlayer

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ContentViewModel

    @State private var time: Date
    @State private var isActive: Bool
    @State private var soundFile: String
    @State private var showMusicPicker = false // Nowy stan dla muzycznego pickera
    @State private var selectedSoundFile: String? // Wybrany dźwięk
    let existingAlarm: AlarmModel?

    init(alarm: AlarmModel?, viewModel: ContentViewModel) {
        self.viewModel = viewModel
        self.existingAlarm = alarm

        _time = State(initialValue: alarm?.time ?? Date())
        _isActive = State(initialValue: alarm?.isActive ?? true)
        _soundFile = State(initialValue: alarm?.soundFile ?? "defaultSound")
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Ustaw Budzik")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                // Picker do godziny
                DatePicker("Godzina", selection: $time, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()

                // Przełącznik aktywności budzika
                Toggle("Włączony", isOn: $isActive)
                    .padding()

                // Wybór dźwięku
                HStack {
                    Text("Dźwięk: \(selectedSoundFile ?? soundFile)")
                        .padding()

                    Button("Wybierz muzykę") {
                        showMusicPicker.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }

                Button(action: saveAlarm) {
                    Text("Zapisz")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationBarItems(leading: Button("Anuluj") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showMusicPicker) {
                MusicPickerView(isPresented: $showMusicPicker, selectedFile: $selectedSoundFile)
            }
        }
    }

    func saveAlarm() {
        let newAlarm = AlarmModel(id: existingAlarm?.id ?? UUID(), time: time, isActive: isActive, soundFile: selectedSoundFile ?? soundFile)

        if existingAlarm == nil {
            viewModel.addAlarm(newAlarm)
        } else {
            viewModel.updateAlarm(newAlarm)
        }

        presentationMode.wrappedValue.dismiss()
    }
}

struct MusicPickerView: UIViewControllerRepresentable {
    class Coordinator: NSObject, MPMediaPickerControllerDelegate {
        var parent: MusicPickerView

        init(parent: MusicPickerView) {
            self.parent = parent
        }

        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            if let firstItem = mediaItemCollection.items.first {
                parent.selectedFile = firstItem.title // Lub dowolna inna właściwość
            }
            parent.isPresented = false
        }

        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            parent.isPresented = false
        }
    }

    @Binding var isPresented: Bool
    @Binding var selectedFile: String?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MPMediaPickerController {
        let picker = MPMediaPickerController(mediaTypes: .music)
        picker.delegate = context.coordinator
        picker.allowsPickingMultipleItems = false
        return picker
    }

    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {}
}
