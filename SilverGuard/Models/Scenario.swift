import Foundation

// MARK: - Scenario Difficulty
enum ScenarioDifficulty: String, CaseIterable {
    case easy   = "Easy"
    case medium = "Medium"
    case hard   = "Hard"
}

// MARK: - Scenario Format
enum ScenarioFormat: String, CaseIterable {
    case phoneCall  = "Phone Call"
    case textMessage = "Text Message"
}

// MARK: - Scenario Status
enum ScenarioStatus {
    case unattempted
    case completed(points: Int)
    case recommendedNext
}

// MARK: - Scenario Model
struct Scenario: Identifiable {
    let id: UUID
    let title: String
    let category: String
    let description: String
    let icon: String          // SF Symbol name
    let iconColor: String     // hex
    let iconBackground: String // hex
    let format: ScenarioFormat
    let difficulty: ScenarioDifficulty
    let durationMinutes: Int
    var status: ScenarioStatus

    init(id: UUID = UUID(),
         title: String,
         category: String,
         description: String,
         icon: String,
         iconColor: String,
         iconBackground: String,
         format: ScenarioFormat = .phoneCall,
         difficulty: ScenarioDifficulty,
         durationMinutes: Int,
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
        self.status = status
    }
}

// MARK: - Mock Data
extension Scenario {
    static let mockScenarios: [Scenario] = [
        Scenario(
            title: "Grandchild in Trouble",
            category: "HIGH URGENCY SCAM",
            description: "An emotional voice call asking for immediate emergency bail money via wire transfer.",
            icon: "person.fill.questionmark",
            iconColor: "B3261E",
            iconBackground: "FDECEA",
            difficulty: .medium,
            durationMinutes: 4,
            status: .recommendedNext
        ),
        Scenario(
            title: "Fake Bank Fraud Alert",
            category: "BANK IMPERSONATION",
            description: "Caller claims your debit card has been blocked and demands your secure PIN to unlock it.",
            icon: "phone.arrow.down.left",
            iconColor: "396285",
            iconBackground: "E8F0FA",
            difficulty: .easy,
            durationMinutes: 3,
            status: .completed(points: 10)
        ),
        Scenario(
            title: "Fake IRS Agent Threat",
            category: "GOVERNMENT SCAM",
            description: "Caller aggressively threatens immediate police arrest unless back taxes are paid in gift cards.",
            icon: "building.columns.fill",
            iconColor: "B3261E",
            iconBackground: "FDECEA",
            difficulty: .hard,
            durationMinutes: 5,
            status: .unattempted
        ),
        Scenario(
            title: "Tech Support Pop-Up",
            category: "REMOTE ACCESS SCAM",
            description: "Caller instructs you to install remote software to remove an alleged security virus on your computer.",
            icon: "desktopcomputer",
            iconColor: "396285",
            iconBackground: "E8F0FA",
            difficulty: .medium,
            durationMinutes: 4,
            status: .unattempted
        )
    ]

    static let featuredScenario = mockScenarios[1]
}
