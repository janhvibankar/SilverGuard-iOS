import Foundation

// MARK: - Practice State (tracks user progress)
class PracticeState: ObservableObject {
    @Published var trustScore: Int = 72
    @Published var scenariosCompleted: Int = 6
    @Published var dayStreak: Int = 3
    @Published var badgesEarned: Int = 2
    @Published var totalBadges: Int = 12
    @Published var scamsAvoided: Int = 6

    @Published var selectedScenario: Scenario? = nil
    @Published var isInSimulation: Bool = false
    @Published var currentSimulationStep: Int = 0

    // MARK: - Badges
    struct Badge: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
        let iconColor: String
        let iconBackground: String
        let isEarned: Bool
    }

    let badges: [Badge] = [
        Badge(title: "Gift Card Guardian",  subtitle: "Awarded yesterday",       icon: "shield.fill",   iconColor: "B26A00", iconBackground: "FFF3E0", isEarned: true),
        Badge(title: "Hang-Up Hero",        subtitle: "Awarded Friday",          icon: "phone.down.fill", iconColor: "1B7F3B", iconBackground: "E8F5EC", isEarned: true),
        Badge(title: "Safe Word Star",      subtitle: "Complete today's call",   icon: "lock.fill",     iconColor: "C2C7CE", iconBackground: "F0EDED", isEarned: false)
    ]

    func selectScenario(_ scenario: Scenario) {
        selectedScenario = scenario
    }
}
