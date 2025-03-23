import SwiftUI

class ChallengeViewModel: ObservableObject {
    @Published var currentChallenge: ChallengeModel = ChallengeModel.randomChallenge()
    @Published var solvedTasks = 0
    @Published var userAnswer = ""

    func checkAnswer() {
        if userAnswer == currentChallenge.correctAnswer {
            solvedTasks += 1
            if solvedTasks < 3 {
                userAnswer = ""
                currentChallenge = ChallengeModel.randomChallenge() // Nowe zadanie
            }
        }
    }
}
