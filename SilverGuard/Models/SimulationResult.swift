import Foundation
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - Simulation Result Model
// Document Path: users/{userId}/simulationResults/{resultId}
public struct SimulationResult: Codable, Identifiable {
    public var id: String?
    public var scenarioId: String
    public var score: Int
    public var completed: Bool
    public var correct: Bool
    public var selectedAnswerId: String
    public var durationSeconds: Int
    public var createdAt: Date

    public init(id: String? = nil,
                scenarioId: String,
                score: Int,
                completed: Bool,
                correct: Bool,
                selectedAnswerId: String,
                durationSeconds: Int,
                createdAt: Date = Date()) {
        self.id = id
        self.scenarioId = scenarioId
        self.score = score
        self.completed = completed
        self.correct = correct
        self.selectedAnswerId = selectedAnswerId
        self.durationSeconds = durationSeconds
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case scenarioId
        case score
        case completed
        case correct
        case selectedAnswerId
        case durationSeconds
        case createdAt
    }
}
