import Foundation
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - Scenario Progress Status
public enum ScenarioProgressStatus: String, Codable, CaseIterable {
    case unattempted = "unattempted"
    case inProgress   = "inProgress"
    case completed    = "completed"
}

// MARK: - Scenario Progress Model
// Document Path: users/{userId}/scenarioProgress/{scenarioId}
public struct ScenarioProgress: Codable, Identifiable {
    public var id: String? { scenarioId }
    public var scenarioId: String
    public var status: ScenarioProgressStatus
    public var bestScore: Int
    public var attempts: Int
    public var startedAt: Date?
    public var completedAt: Date?
    public var lastAttemptAt: Date?

    public init(scenarioId: String,
                status: ScenarioProgressStatus = .unattempted,
                bestScore: Int = 0,
                attempts: Int = 0,
                startedAt: Date? = nil,
                completedAt: Date? = nil,
                lastAttemptAt: Date? = nil) {
        self.scenarioId = scenarioId
        self.status = status
        self.bestScore = bestScore
        self.attempts = attempts
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.lastAttemptAt = lastAttemptAt
    }

    enum CodingKeys: String, CodingKey {
        case scenarioId
        case status
        case bestScore
        case attempts
        case startedAt
        case completedAt
        case lastAttemptAt
    }
}
