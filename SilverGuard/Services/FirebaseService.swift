import Foundation
import Combine
#if canImport(FirebaseAuth)
import FirebaseAuth
#endif
#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif
#if canImport(FirebaseFirestoreSwift)
import FirebaseFirestoreSwift
#endif

// MARK: - Service Errors
public enum FirebaseServiceError: LocalizedError {
    case unauthenticated
    case userNotFound
    case documentNotFound
    case encodingFailed
    case decodingFailed
    case networkError(String)

    public var errorDescription: String? {
        switch self {
        case .unauthenticated:
            return "Please sign in to continue."
        case .userNotFound:
            return "User account could not be found."
        case .documentNotFound:
            return "The requested record does not exist."
        case .encodingFailed:
            return "Failed to encode data for storage."
        case .decodingFailed:
            return "Failed to parse data from server."
        case .networkError(let message):
            return "Connection error: \(message)"
        }
    }
}

// MARK: - Firebase Service
// Central abstraction between SwiftUI Views/State and Firebase Authentication & Cloud Firestore.
public final class FirebaseService: ObservableObject {
    public static let shared = FirebaseService()

    #if canImport(FirebaseAuth)
    private var auth: Auth { Auth.auth() }
    #endif

    #if canImport(FirebaseFirestore)
    private var db: Firestore { Firestore.firestore() }
    #endif

    public init() {}

    // MARK: - Helper UID Resolution
    public var currentUserID: String? {
        #if canImport(FirebaseAuth)
        return Auth.auth().currentUser?.uid
        #else
        return nil
        #endif
    }

    #if canImport(FirebaseAuth)
    public var currentUser: User? {
        Auth.auth().currentUser
    }

    // MARK: - Authentication Methods
    public func addAuthStateListener(handler: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            handler(user)
        }
    }

    public func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }

    public func createAccount(email: String, password: String) async throws -> AuthDataResult {
        return try await auth.createUser(withEmail: email, password: password)
    }

    public func signIn(email: String, password: String) async throws -> AuthDataResult {
        return try await auth.signIn(withEmail: email, password: password)
    }

    public func signOut() throws {
        try auth.signOut()
    }

    /// Development / Senior Zero-Barrier Hook: Isolated Anonymous Sign-In
    public func signInAnonymously() async throws -> AuthDataResult {
        return try await auth.signInAnonymously()
    }
    #endif

    // MARK: - User Profile (users/{userId}/profile/data)
    public func saveUserProfile(_ profile: UserProfile, userId: String? = nil) async throws {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("users").document(uid).collection("profile").document("data")
        try docRef.setData(from: profile, merge: true)
        #endif
    }

    public func fetchUserProfile(userId: String? = nil) async throws -> UserProfile? {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("users").document(uid).collection("profile").document("data")
        let snapshot = try await docRef.getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: UserProfile.self)
        #else
        return nil
        #endif
    }

    // MARK: - Scenarios (scenarios/{scenarioId})
    public func fetchScenario(scenarioId: String) async throws -> Scenario? {
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("scenarios").document(scenarioId)
        let snapshot = try await docRef.getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: Scenario.self)
        #else
        return nil
        #endif
    }

    public func fetchScenarios() async throws -> [Scenario] {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("scenarios")
            .whereField("isActive", isEqualTo: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Scenario.self) }
        #else
        return []
        #endif
    }

    // MARK: - Scenario Progress (users/{userId}/scenarioProgress/{scenarioId})
    public func saveScenarioProgress(_ progress: ScenarioProgress, userId: String? = nil) async throws {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("users")
            .document(uid)
            .collection("scenarioProgress")
            .document(progress.scenarioId)
        try docRef.setData(from: progress, merge: true)
        #endif
    }

    public func fetchScenarioProgress(scenarioId: String, userId: String? = nil) async throws -> ScenarioProgress? {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("users")
            .document(uid)
            .collection("scenarioProgress")
            .document(scenarioId)
        let snapshot = try await docRef.getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: ScenarioProgress.self)
        #else
        return nil
        #endif
    }

    public func fetchAllScenarioProgress(userId: String? = nil) async throws -> [ScenarioProgress] {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("users")
            .document(uid)
            .collection("scenarioProgress")
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ScenarioProgress.self) }
        #else
        return []
        #endif
    }

    // MARK: - Simulation Results (users/{userId}/simulationResults/{resultId})
    public func saveSimulationResult(_ result: SimulationResult, userId: String? = nil) async throws -> String {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docId = result.id ?? UUID().uuidString
        var payload = result
        payload.id = docId
        let docRef = db.collection("users")
            .document(uid)
            .collection("simulationResults")
            .document(docId)
        try docRef.setData(from: payload)
        return docId
        #else
        return result.id ?? UUID().uuidString
        #endif
    }

    public func fetchSimulationResult(resultId: String, userId: String? = nil) async throws -> SimulationResult? {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docRef = db.collection("users")
            .document(uid)
            .collection("simulationResults")
            .document(resultId)
        let snapshot = try await docRef.getDocument()
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: SimulationResult.self)
        #else
        return nil
        #endif
    }

    public func fetchSimulationResults(userId: String? = nil, limit: Int = 20) async throws -> [SimulationResult] {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("users")
            .document(uid)
            .collection("simulationResults")
            .order(by: "createdAt", descending: true)
            .limit(to: limit)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: SimulationResult.self) }
        #else
        return []
        #endif
    }

    // MARK: - Family Connections (users/{userId}/familyConnections/{connectionId})
    public func saveFamilyConnection(_ connection: FamilyConnection, userId: String? = nil) async throws {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docId = connection.id ?? UUID().uuidString
        var payload = connection
        payload.id = docId
        let docRef = db.collection("users")
            .document(uid)
            .collection("familyConnections")
            .document(docId)
        try docRef.setData(from: payload, merge: true)
        #endif
    }

    public func fetchFamilyConnections(userId: String? = nil) async throws -> [FamilyConnection] {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("users")
            .document(uid)
            .collection("familyConnections")
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: FamilyConnection.self) }
        #else
        return []
        #endif
    }

    public func deleteFamilyConnection(connectionId: String, userId: String? = nil) async throws {
        guard let uid = userId ?? currentUserID else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        try await db.collection("users")
            .document(uid)
            .collection("familyConnections")
            .document(connectionId)
            .delete()
        #endif
    }

    // MARK: - Family Invitations (familyInvitations/{invitationId})
    public func createFamilyInvitation(_ invitation: FamilyInvitation) async throws -> String {
        guard currentUserID != nil else { throw FirebaseServiceError.unauthenticated }
        #if canImport(FirebaseFirestore)
        let docId = invitation.id ?? UUID().uuidString
        var payload = invitation
        payload.id = docId
        let docRef = db.collection("familyInvitations").document(docId)
        try docRef.setData(from: payload)
        return docId
        #else
        return invitation.id ?? UUID().uuidString
        #endif
    }

    public func fetchFamilyInvitations(forEmail email: String) async throws -> [FamilyInvitation] {
        #if canImport(FirebaseFirestore)
        let snapshot = try await db.collection("familyInvitations")
            .whereField("recipientEmail", isEqualTo: email)
            .whereField("status", isEqualTo: FamilyInvitationStatus.pending.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: FamilyInvitation.self) }
        #else
        return []
        #endif
    }

    public func updateFamilyInvitationStatus(invitationId: String, status: FamilyInvitationStatus) async throws {
        #if canImport(FirebaseFirestore)
        try await db.collection("familyInvitations")
            .document(invitationId)
            .updateData(["status": status.rawValue])
        #endif
    }
}
