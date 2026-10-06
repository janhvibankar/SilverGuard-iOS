import Foundation
import Combine
import SwiftUI

// MARK: - Practice State (tracks user progress and interfaces with Firebase)
@MainActor
public class PracticeState: ObservableObject {
    // ─── Existing Properties (preserved for UI compatibility) ───────────
    @Published public var trustScore: Int = 72
    @Published public var scenariosCompleted: Int = 6
    @Published public var dayStreak: Int = 3
    @Published public var badgesEarned: Int = 2
    @Published public var totalBadges: Int = 12
    @Published public var scamsAvoided: Int = 6

    @Published public var selectedScenario: Scenario? = nil
    @Published public var isInSimulation: Bool = false
    @Published public var currentSimulationStep: Int = 0

    // ─── Firebase Persistence Layer State ─────────────────────────────
    @Published public var userProfile: UserProfile? = nil
    @Published public var scenarios: [Scenario] = Scenario.mockScenarios
    @Published public var scenarioProgress: [String: ScenarioProgress] = [:]
    @Published public var familyConnections: [FamilyConnection] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    private let firebaseService: FirebaseService

    // MARK: - Badges Model
    public struct Badge: Identifiable {
        public let id = UUID()
        public let title: String
        public let subtitle: String
        public let icon: String
        public let iconColor: String
        public let iconBackground: String
        public let isEarned: Bool

        public init(title: String, subtitle: String, icon: String, iconColor: String, iconBackground: String, isEarned: Bool) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.iconColor = iconColor
            self.iconBackground = iconBackground
            self.isEarned = isEarned
        }
    }

    @Published public var badges: [Badge] = [
        Badge(title: "Gift Card Guardian",  subtitle: "Awarded yesterday",       icon: "shield.fill",     iconColor: "B26A00", iconBackground: "FFF3E0", isEarned: true),
        Badge(title: "Hang-Up Hero",        subtitle: "Awarded Friday",          icon: "phone.down.fill", iconColor: "1B7F3B", iconBackground: "E8F5EC", isEarned: true),
        Badge(title: "Safe Word Star",      subtitle: "Complete today's call",   icon: "lock.fill",       iconColor: "C2C7CE", iconBackground: "F0EDED", isEarned: false)
    ]

    // MARK: - Initializer
    public init(service: FirebaseService = .shared) {
        self.firebaseService = service

        // Kick off asynchronous initialization & data load
        Task {
            await loadInitialData()
        }
    }

    public func selectScenario(_ scenario: Scenario) {
        self.selectedScenario = scenario
    }

    // MARK: - Data Synchronization
    public func loadInitialData() async {
        self.isLoading = true
        defer { self.isLoading = false }

        do {
            #if canImport(FirebaseAuth)
            // Ensure an active user session exists (isolated anonymous auth for zero-barrier senior use)
            if firebaseService.currentUserID == nil {
                _ = try? await firebaseService.signInAnonymously()
            }
            #endif

            // 1. Fetch User Profile
            if let profile = try await firebaseService.fetchUserProfile() {
                self.syncFromProfile(profile)
            } else if let uid = firebaseService.currentUserID {
                // Seed initial profile on first launch
                let initialProfile = UserProfile(id: uid)
                try? await firebaseService.saveUserProfile(initialProfile)
                self.syncFromProfile(initialProfile)
            }

            // 2. Fetch Remote Scenarios with Local Fallback
            let remoteScenarios = try await firebaseService.fetchScenarios()
            if !remoteScenarios.isEmpty {
                self.scenarios = remoteScenarios
            } else {
                self.scenarios = Scenario.mockScenarios
            }

            // 3. Fetch User's Scenario Progress
            let progressList = try await firebaseService.fetchAllScenarioProgress()
            for prog in progressList {
                self.scenarioProgress[prog.scenarioId] = prog
            }

            // Merge progress into scenarios list for UI badges
            self.applyProgressToScenarios()

            // 4. Fetch Family Connections
            let remoteConnections = try await firebaseService.fetchFamilyConnections()
            if !remoteConnections.isEmpty {
                self.familyConnections = remoteConnections
            } else {
                // Default fallback connections for senior reassurance
                self.familyConnections = [
                    FamilyConnection(memberUserId: "sarah_daughter", memberName: "Sarah (Daughter)", relationship: "Daughter", status: .accepted, weeklyReports: true, scamAlerts: false),
                    FamilyConnection(memberUserId: "james_son", memberName: "James (Son)", relationship: "Son", status: .accepted, weeklyReports: false, scamAlerts: true)
                ]
            }
        } catch {
            self.errorMessage = "Loaded in offline safety mode."
            // Fallback gracefully to default local data
            if self.scenarios.isEmpty {
                self.scenarios = Scenario.mockScenarios
            }
        }
    }

    private func syncFromProfile(_ profile: UserProfile) {
        self.userProfile = profile
        self.trustScore = profile.trustScore
        self.scenariosCompleted = profile.scenariosCompleted
        self.dayStreak = profile.dayStreak
        self.badgesEarned = profile.badgesEarned
        self.totalBadges = profile.totalBadges
        self.scamsAvoided = profile.scamsAvoided
    }

    private func applyProgressToScenarios() {
        for idx in 0..<scenarios.count {
            let scId = scenarios[idx].id
            if let prog = scenarioProgress[scId] {
                scenarios[idx].updateStatus(from: prog)
            }
        }
    }

    // MARK: - Simulation Completion Handler (Phase 10)
    public func recordSimulationCompletion(scenario: Scenario,
                                           answerId: String,
                                           isCorrect: Bool,
                                           durationSeconds: Int) async {
        let earnedScore = isCorrect ? 10 : 2
        let resultId = UUID().uuidString

        // 1. Create and Save Simulation Result
        let simResult = SimulationResult(
            id: resultId,
            scenarioId: scenario.id,
            score: earnedScore,
            completed: true,
            correct: isCorrect,
            selectedAnswerId: answerId,
            durationSeconds: durationSeconds,
            createdAt: Date()
        )
        _ = try? await firebaseService.saveSimulationResult(simResult)

        // 2. Update Scenario Progress
        var existingAttempts = scenarioProgress[scenario.id]?.attempts ?? 0
        existingAttempts += 1
        let currentBest = scenarioProgress[scenario.id]?.bestScore ?? 0
        let newBest = max(currentBest, earnedScore)

        let updatedProgress = ScenarioProgress(
            scenarioId: scenario.id,
            status: .completed,
            bestScore: newBest,
            attempts: existingAttempts,
            startedAt: scenarioProgress[scenario.id]?.startedAt ?? Date().addingTimeInterval(-Double(durationSeconds)),
            completedAt: Date(),
            lastAttemptAt: Date()
        )
        self.scenarioProgress[scenario.id] = updatedProgress
        _ = try? await firebaseService.saveScenarioProgress(updatedProgress)

        // 3. Update User Profile Aggregates
        var profile = self.userProfile ?? UserProfile(id: firebaseService.currentUserID)
        profile.scenariosCompleted += 1
        if isCorrect {
            profile.scamsAvoided += 1
            profile.trustScore = min(100, profile.trustScore + 4)
        }
        profile.updatedAt = Date()
        self.syncFromProfile(profile)
        _ = try? await firebaseService.saveUserProfile(profile)

        // 4. Update in-memory scenario status
        self.applyProgressToScenarios()
    }

    // MARK: - Family Hub Actions (Phase 11)
    public func sendFamilyInvitation(recipientEmail: String, relationship: String) async throws -> String {
        guard let uid = firebaseService.currentUserID else {
            throw FirebaseServiceError.unauthenticated
        }
        let invitation = FamilyInvitation(
            senderUserId: uid,
            recipientEmail: recipientEmail,
            relationship: relationship,
            status: .pending,
            createdAt: Date(),
            expiresAt: Date().addingTimeInterval(7 * 24 * 60 * 60)
        )
        let inviteId = try await firebaseService.createFamilyInvitation(invitation)

        // Also add pending local connection row
        let newConnection = FamilyConnection(
            memberUserId: recipientEmail,
            memberName: "\(recipientEmail) (\(relationship))",
            relationship: relationship,
            status: .pending,
            weeklyReports: true,
            scamAlerts: true,
            createdAt: Date(),
            updatedAt: Date()
        )
        self.familyConnections.append(newConnection)
        _ = try? await firebaseService.saveFamilyConnection(newConnection)

        return inviteId
    }
}
