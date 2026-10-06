import Foundation
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - Family Invitation Status
public enum FamilyInvitationStatus: String, Codable, CaseIterable {
    case pending   = "pending"
    case accepted  = "accepted"
    case declined  = "declined"
    case expired   = "expired"
}

// MARK: - Family Invitation Model
// Document Path: familyInvitations/{invitationId}
public struct FamilyInvitation: Codable, Identifiable {
    public var id: String?
    public var senderUserId: String
    public var recipientEmail: String
    public var relationship: String
    public var status: FamilyInvitationStatus
    public var createdAt: Date
    public var expiresAt: Date

    public init(id: String? = nil,
                senderUserId: String,
                recipientEmail: String,
                relationship: String,
                status: FamilyInvitationStatus = .pending,
                createdAt: Date = Date(),
                expiresAt: Date = Date().addingTimeInterval(7 * 24 * 60 * 60)) {
        self.id = id
        self.senderUserId = senderUserId
        self.recipientEmail = recipientEmail
        self.relationship = relationship
        self.status = status
        self.createdAt = createdAt
        self.expiresAt = expiresAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case senderUserId
        case recipientEmail
        case relationship
        case status
        case createdAt
        case expiresAt
    }
}
