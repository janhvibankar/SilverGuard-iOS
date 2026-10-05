import SwiftUI

struct FamilyView: View {
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

                        PrimaryButton(title: "Send Invitation", systemImage: "envelope.fill") {}
                    }
                    .frame(maxWidth: .infinity)
                    .silverCard()

                    // Connected members placeholder
                    SectionHeader(title: "Connected Members")

                    VStack(spacing: 0) {
                        FamilyMemberRow(name: "Sarah (Daughter)", status: "Gets weekly reports", icon: "person.fill", isLast: false)
                        FamilyMemberRow(name: "James (Son)", status: "Receives scam alerts", icon: "person.fill", isLast: true)
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
        }
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
