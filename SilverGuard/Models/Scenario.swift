import Foundation

// MARK: - Scenario Difficulty
public enum ScenarioDifficulty: String, CaseIterable, Codable {
    case easy   = "Easy"
    case medium = "Medium"
    case hard   = "Hard"
}

// MARK: - Scenario Format
public enum ScenarioFormat: String, CaseIterable, Codable {
    case phoneCall   = "Phone Call"
    case textMessage = "Text Message"
}

// MARK: - UI-Only Transient Scenario Status
// Note: This status is decoupled from Firestore global scenario docs
// and populated at runtime from user-specific ScenarioProgress.
public enum ScenarioStatus: Equatable, Hashable {
    case unattempted
    case completed(points: Int)
    case recommendedNext
}

// MARK: - Global Scenario Model
// Document Path: scenarios/{scenarioId}
public struct Scenario: Identifiable, Codable, Hashable {
    public var id: String
    public var title: String
    public var category: String
    public var description: String
    public var icon: String           // SF Symbol name
    public var iconColor: String      // hex string
    public var iconBackground: String // hex string
    public var format: ScenarioFormat
    public var difficulty: ScenarioDifficulty
    public var durationMinutes: Int
    public var isActive: Bool

    // Transient UI status derived from user's ScenarioProgress (not saved in global Firestore doc)
    public var status: ScenarioStatus

    public init(id: String,
                title: String,
                category: String,
                description: String,
                icon: String,
                iconColor: String,
                iconBackground: String,
                format: ScenarioFormat = .phoneCall,
                difficulty: ScenarioDifficulty,
                durationMinutes: Int,
                isActive: Bool = true,
                status: ScenarioStatus = .unattempted) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.icon = icon
        self.iconColor = iconColor
        self.iconBackground = iconBackground
        self.format = format
        self.difficulty = difficulty
        self.durationMinutes = durationMinutes
        self.isActive = isActive
        self.status = status
    }

    // Decouple user-specific status from global Firestore doc
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category
        case description
        case icon
        case iconColor
        case iconBackground
        case format
        case difficulty
        case durationMinutes
        case isActive
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.category = try container.decode(String.self, forKey: .category)
        self.description = try container.decode(String.self, forKey: .description)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.iconColor = try container.decode(String.self, forKey: .iconColor)
        self.iconBackground = try container.decode(String.self, forKey: .iconBackground)
        self.format = try container.decode(ScenarioFormat.self, forKey: .format)
        self.difficulty = try container.decode(ScenarioDifficulty.self, forKey: .difficulty)
        self.durationMinutes = try container.decode(Int.self, forKey: .durationMinutes)
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        self.status = .unattempted
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(category, forKey: .category)
        try container.encode(description, forKey: .description)
        try container.encode(icon, forKey: .icon)
        try container.encode(iconColor, forKey: .iconColor)
        try container.encode(iconBackground, forKey: .iconBackground)
        try container.encode(format, forKey: .format)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(durationMinutes, forKey: .durationMinutes)
        try container.encode(isActive, forKey: .isActive)
    }

    public mutating func updateStatus(from progress: ScenarioProgress) {
        switch progress.status {
        case .unattempted:
            self.status = .unattempted
        case .inProgress:
            self.status = .unattempted
        case .completed:
            self.status = .completed(points: progress.bestScore > 0 ? progress.bestScore : 10)
        }
    }
}

// MARK: - Mock / Local Fallback Data
extension Scenario {
    public static let mockScenarios: [Scenario] = [
        Scenario(
            id: "grandchild_in_trouble",
            title: "Grandchild in Trouble",
            category: "HIGH URGENCY SCAM",
            description: "An emotional voice call asking for immediate emergency bail money via wire transfer.",
            icon: "person.fill.questionmark",
            iconColor: "B3261E",
            iconBackground: "FDECEA",
            format: .phoneCall,
            difficulty: .medium,
            durationMinutes: 4,
            isActive: true,
            status: .recommendedNext
        ),
        Scenario(
            id: "fake_bank_fraud_alert",
            title: "Fake Bank Fraud Alert",
            category: "BANK IMPERSONATION",
            description: "Caller claims your debit card has been blocked and demands your secure PIN to unlock it.",
            icon: "phone.arrow.down.left",
            iconColor: "396285",
            iconBackground: "E8F0FA",
            format: .phoneCall,
            difficulty: .easy,
            durationMinutes: 3,
            isActive: true,
            status: .completed(points: 10)
        ),
        Scenario(
            id: "fake_irs_agent_threat",
            title: "Fake IRS Agent Threat",
            category: "GOVERNMENT SCAM",
            description: "Caller aggressively threatens immediate police arrest unless back taxes are paid in gift cards.",
            icon: "building.columns.fill",
            iconColor: "B3261E",
            iconBackground: "FDECEA",
            format: .phoneCall,
            difficulty: .hard,
            durationMinutes: 5,
            isActive: true,
            status: .unattempted
        ),
        Scenario(
            id: "tech_support_popup",
            title: "Tech Support Pop-Up",
            category: "REMOTE ACCESS SCAM",
            description: "Caller instructs you to install remote software to remove an alleged security virus on your computer.",
            icon: "desktopcomputer",
            iconColor: "396285",
            iconBackground: "E8F0FA",
            format: .phoneCall,
            difficulty: .medium,
            durationMinutes: 4,
            isActive: true,
            status: .unattempted
        )
    ]

    public static var featuredScenario: Scenario {
        mockScenarios[1]
    }
}
