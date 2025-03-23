import SwiftUI

struct AlarmChallengeView: View {
    @StateObject private var viewModel = ChallengeViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Rozwiąż 3 zadania, aby wyłączyć alarm!")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(viewModel.currentChallenge.question)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            TextField("Twoja odpowiedź", text: $viewModel.userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .multilineTextAlignment(.center)
                
            Button(action: {
                viewModel.checkAnswer()
                if viewModel.solvedTasks >= 3 {
                    AlarmManager.shared.stopAlarm()
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Sprawdź odpowiedź")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Text("Zadania rozwiązane: \(viewModel.solvedTasks)/3")
                .font(.headline)
        }
        .onAppear {
            AlarmManager.shared.playSound(named: "alarmSound")
        }
    }
}
