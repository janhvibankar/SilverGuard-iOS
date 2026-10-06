import Foundation
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - Family Connection Status
public enum FamilyConnectionStatus: String, Codable, CaseIterable {
    case pending   = "pending"
    case accepted  = "accepted"
    case declined  = "declined"
    case revoked   = "revoked"
}

// MARK: - Family Connection Model
// Document Path: users/{userId}/familyConnections/{connectionId}
public struct FamilyConnection: Codable, Identifiable {
    public var id: String?
    public var memberUserId: String
    public var memberName: String
    public var relationship: String
    public var status: FamilyConnectionStatus
    public var weeklyReports: Bool
    public var scamAlerts: Bool
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: String? = nil,
                memberUserId: String,
                memberName: String,
                relationship: String,
                status: FamilyConnectionStatus = .accepted,
                weeklyReports: Bool = true,
                scamAlerts: Bool = true,
                createdAt: Date = Date(),
                updatedAt: Date = Date()) {
        self.id = id
        self.memberUserId = memberUserId
        self.memberName = memberName
        self.relationship = relationship
        self.status = status
        self.weeklyReports = weeklyReports
        self.scamAlerts = scamAlerts
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case memberUserId
        case memberName
        case relationship
        case status
        case weeklyReports
        case scamAlerts
        case createdAt
        case updatedAt
    }
}
