import Foundation

enum ChallengeType: CaseIterable {
    case math, memory, logic
}

struct ChallengeModel {
    let type: ChallengeType
    let question: String
    let correctAnswer: String

    static func randomChallenge() -> ChallengeModel {
        let type = ChallengeType.allCases.randomElement()!

        switch type {
        case .math:
            let a = Int.random(in: 1...10)
            let b = Int.random(in: 1...10)
            return ChallengeModel(type: .math, question: "Ile to \(a) + \(b)?", correctAnswer: "\(a + b)")

        case .memory:
            let words = ["kot", "pies", "dom", "drzewo", "słońce"]
            let selectedWord = words.randomElement()!
            return ChallengeModel(type: .memory, question: "Zapamiętaj to słowo: \(selectedWord)", correctAnswer: selectedWord)

        case .logic:
            return ChallengeModel(type: .logic, question: "Co jest większe: 5 czy 3?", correctAnswer: "5")
        }
    }
}
