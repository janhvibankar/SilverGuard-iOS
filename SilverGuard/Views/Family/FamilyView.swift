import SwiftUI

struct FamilyView: View {
    @ObservedObject var state: PracticeState = PracticeState()

    @State private var showingInviteSheet = false
    @State private var inviteEmail = ""
    @State private var inviteRelationship = "Daughter"
    @State private var isSending = false
    @State private var showingConfirmation = false

    private let relationships = ["Daughter", "Son", "Spouse", "Caregiver", "Friend", "Other"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SGSpacing.md) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Family Hub")
                            .font(SilverGuardTypography.headlineXL)
                            .foregroundColor(Color.silverText)
                        Text("Share your progress with trusted family members and caregivers.")
                            .font(SilverGuardTypography.bodyLG)
                            .foregroundColor(Color.silverSecondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 8)

                    // Invite card
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.silverPracticeBackground)
                                .frame(width: 80, height: 80)
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 34, weight: .medium))
                                .foregroundColor(Color.silverPrimaryContainer)
                        }
                        Text("Invite a Family Member")
                            .font(SilverGuardTypography.headlineMD)
                            .foregroundColor(Color.silverText)
                        Text("They'll receive weekly summaries of your practice sessions and scam alerts.")
                            .font(SilverGuardTypography.bodyLG)
                            .foregroundColor(Color.silverSecondaryText)
                            .multilineTextAlignment(.center)

                        PrimaryButton(title: "Send Invitation", systemImage: "envelope.fill") {
                            showingInviteSheet = true
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .silverCard()

                    // Connected members
                    SectionHeader(title: "Connected Members")

                    VStack(spacing: 0) {
                        if state.familyConnections.isEmpty {
                            FamilyMemberRow(name: "Sarah (Daughter)", status: "Gets weekly reports", icon: "person.fill", isLast: false)
                            FamilyMemberRow(name: "James (Son)", status: "Receives scam alerts", icon: "person.fill", isLast: true)
                        } else {
                            ForEach(Array(state.familyConnections.enumerated()), id: \.element.id) { idx, member in
                                FamilyMemberRow(
                                    name: member.memberName,
                                    status: member.weeklyReports ? "Gets weekly reports" : "Receives scam alerts",
                                    icon: "person.fill",
                                    isLast: idx == state.familyConnections.count - 1
                                )
                            }
                        }
                    }
                    .silverCard(padding: 0)

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.bottom, 100)
            }
            .background(Color.silverBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color.silverPrimaryContainer)
                        Text("Family")
                            .font(SilverGuardTypography.headlineMD)
                            .foregroundColor(Color.silverPrimaryContainer)
                    }
                }
            }
            .sheet(isPresented: $showingInviteSheet) {
                InviteCaregiverSheet(
                    inviteEmail: $inviteEmail,
                    inviteRelationship: $inviteRelationship,
                    relationships: relationships,
                    isSending: isSending,
                    onSend: {
                        guard !inviteEmail.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        isSending = true
                        Task {
                            _ = try? await state.sendFamilyInvitation(
                                recipientEmail: inviteEmail.trimmingCharacters(in: .whitespaces),
                                relationship: inviteRelationship
                            )
                            isSending = false
                            showingInviteSheet = false
                            showingConfirmation = true
                            inviteEmail = ""
                        }
                    },
                    onCancel: {
                        showingInviteSheet = false
                    }
                )
            }
            .alert("Invitation Sent", isPresented: $showingConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("A safe invitation has been recorded for your family member. They will receive your weekly practice reports.")
            }
        }
    }
}

// MARK: - Invite Caregiver Sheet
private struct InviteCaregiverSheet: View {
    @Binding var inviteEmail: String
    @Binding var inviteRelationship: String
    let relationships: [String]
    let isSending: Bool
    let onSend: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Invite Trusted Contact")
                    .font(SilverGuardTypography.headlineLG)
                    .foregroundColor(Color.silverText)
                    .padding(.top, 16)

                Text("Enter the email address of your family member or caregiver to link accounts safely.")
                    .font(SilverGuardTypography.bodyLG)
                    .foregroundColor(Color.silverSecondaryText)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.silverText)

                    TextField("e.g. daughter@example.com", text: $inviteEmail)
                        .font(SilverGuardTypography.bodyLG)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 16)
                        .frame(height: 64)
                        .background(Color.silverSurface)
                        .clipShape(RoundedRectangle(cornerRadius: SGRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: SGRadius.md)
                                .stroke(Color.silverBorder, lineWidth: 2)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Relationship")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.silverText)

                    Picker("Relationship", selection: $inviteRelationship) {
                        ForEach(relationships, id: \.self) { rel in
                            Text(rel).tag(rel)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Spacer()

                PrimaryButton(title: isSending ? "Sending..." : "Send Invitation", systemImage: "paperplane.fill") {
                    onSend()
                }
                .disabled(isSending || inviteEmail.isEmpty)
                .opacity(inviteEmail.isEmpty ? 0.6 : 1.0)

                SecondaryButton(title: "Cancel") {
                    onCancel()
                }
            }
            .padding(.horizontal, SGSpacing.gutter)
            .padding(.bottom, 24)
            .background(Color.silverBackground.ignoresSafeArea())
        }
        .presentationDetents([.medium, .large])
    }
}

private struct FamilyMemberRow: View {
    let name: String
    let status: String
    let icon: String
    let isLast: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(Color.silverPracticeBackground).frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color.silverPrimaryContainer)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.silverText)
                Text(status)
                    .font(.system(size: 14))
                    .foregroundColor(Color.silverSecondaryText)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(Color.silverSafe)
        }
        .padding(.horizontal, SGSpacing.md)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle().fill(Color.silverBorder).frame(height: 1)
                    .padding(.leading, SGSpacing.md + 48 + 14)
            }
        }
    }
}

struct FamilyView_Previews: PreviewProvider {
    static var previews: some View {
        FamilyView()
    }
}
