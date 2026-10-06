import Foundation
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - User Profile Model
// Document Path: users/{userId}/profile/data
public struct UserProfile: Codable, Identifiable {
    public var id: String?
    public var displayName: String
    public var email: String
    public var trustScore: Int
    public var scenariosCompleted: Int
    public var dayStreak: Int
    public var badgesEarned: Int
    public var totalBadges: Int
    public var scamsAvoided: Int
    public var earnedBadgeIds: [String]
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: String? = nil,
                displayName: String = "Margaret",
                email: String = "margaret@example.com",
                trustScore: Int = 72,
                scenariosCompleted: Int = 6,
                dayStreak: Int = 3,
                badgesEarned: Int = 2,
                totalBadges: Int = 12,
                scamsAvoided: Int = 6,
                earnedBadgeIds: [String] = ["gift_card_guardian", "hang_up_hero"],
                createdAt: Date = Date(),
                updatedAt: Date = Date()) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.trustScore = trustScore
        self.scenariosCompleted = scenariosCompleted
        self.dayStreak = dayStreak
        self.badgesEarned = badgesEarned
        self.totalBadges = totalBadges
        self.scamsAvoided = scamsAvoided
        self.earnedBadgeIds = earnedBadgeIds
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case email
        case trustScore
        case scenariosCompleted
        case dayStreak
        case badgesEarned
        case totalBadges
        case scamsAvoided
        case earnedBadgeIds
        case createdAt
        case updatedAt
    }
}
