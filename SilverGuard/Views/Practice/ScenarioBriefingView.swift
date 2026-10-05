import SwiftUI

struct ScenarioBriefingView: View {
    let scenario: Scenario
    @ObservedObject var state: PracticeState
    @State private var navigateToSimulation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SGSpacing.md) {

                // ─── Step indicator ────────────────────────────────────
                HStack {
                    StepDots(total: 3, current: 0)
                    Spacer()
                    Text("Step 1 of 3")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color.silverSecondaryText)
                }
                .padding(.top, 8)

                // ─── Icon ──────────────────────────────────────────────
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        Circle()
                            .fill(Color.silverPracticeBackground)
                            .frame(width: 96, height: 96)
                        Image(systemName: scenario.icon)
                            .font(.system(size: 38, weight: .medium))
                            .foregroundColor(Color.silverPrimaryContainer)
                    }
                    ZStack {
                        Circle().fill(Color.silverSafe).frame(width: 28, height: 28)
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 4, y: -4)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)

                // ─── Title ─────────────────────────────────────────────
                Text(scenario.title)
                    .font(SilverGuardTypography.headlineXL)
                    .foregroundColor(Color.silverText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)

                // ─── Format / Duration pill ────────────────────────────
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 15))
                    Text("Simulated Call  •  ~\(scenario.durationMinutes) Minutes")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(Color.silverSecondaryText)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(Color.silverSurfaceHigh)
                        .overlay(Capsule().stroke(Color.silverBorder, lineWidth: 1))
                )
                .frame(maxWidth: .infinity, alignment: .center)

                // ─── Safety reassurance card ───────────────────────────
                SafetyReassuranceCard()

                // ─── The Situation card ────────────────────────────────
                SituationCard(scenario: scenario)

                // ─── Golden Safety Rule card ───────────────────────────
                GoldenRuleCard()

                // ─── CTA ───────────────────────────────────────────────
                PrimaryButton(title: "I'm Ready — Start Call  →") {
                    navigateToSimulation = true
                }

                Button {
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "house")
                            .font(.system(size: 15))
                        Text("Need a minute? Return to Home")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color.silverSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(minHeight: 48)

                Spacer(minLength: 20)
            }
            .padding(.horizontal, SGSpacing.gutter)
            .padding(.bottom, 40)
        }
        .background(Color.silverBackground.ignoresSafeArea())
        .navigationTitle("Practice Simulatio…")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    Circle().fill(Color.silverPrimaryContainer).frame(width: 36, height: 36)
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(width: 44, height: 44)
            }
        }
        .navigationDestination(isPresented: $navigateToSimulation) {
            LiveSimulationView(scenario: scenario, state: state)
        }
    }
}

// MARK: - Step Dots Indicator
private struct StepDots: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { idx in
                Circle()
                    .fill(idx == current ? Color.silverPrimaryContainer : Color.silverBorder)
                    .frame(width: idx == current ? 10 : 8, height: idx == current ? 10 : 8)
            }
        }
    }
}

// MARK: - Safety Reassurance Card
private struct SafetyReassuranceCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "smiley")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color.silverPrimaryContainer)

            VStack(alignment: .leading, spacing: 4) {
                Text("You are completely safe.")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.silverPrimaryContainer)
                Text("This is only a quiet simulation. Nobody is actually listening, and your money is 100% untouched.")
                    .font(SilverGuardTypography.bodyLG)
                    .foregroundColor(Color.silverSecondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(SGSpacing.md)
        .background(Color.silverPracticeBackground)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverOutline.opacity(0.5), lineWidth: 1.5)
        )
    }
}

// MARK: - Situation Card
private struct SituationCard: View {
    let scenario: Scenario

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("The Situation")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(Color.silverText)

                Spacer()

                Text("Story")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.silverSecondaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.silverSurfaceHigh)
                    )
            }

            // Illustration placeholder with overlay
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                    .fill(Color.silverSurfaceLow)
                    .frame(height: 160)
                    .overlay(
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color.silverBorder)
                    )

                // Caller ID strip
                HStack(spacing: 6) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 12))
                    Text("Caller ID: Bank Security Dept")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(Color.silverText)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.silverSurface.opacity(0.92))
                )
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous))

            Text("Your telephone rings during your peaceful morning routine. The caller sounds urgent and speaks rapidly, claiming your debit card was just used in another state.")
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .silverCard()
    }
}

// MARK: - Golden Rule Card
private struct GoldenRuleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.silverDanger)
                Text("Golden Safety Rule")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.silverDanger)
            }

            Text("Stop. Hang Up. Call Back.")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "7C1600"))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: SGRadius.md, style: .continuous)
                        .fill(Color.silverSurface)
                        .overlay(
                            RoundedRectangle(cornerRadius: SGRadius.md, style: .continuous)
                                .stroke(Color.silverDanger.opacity(0.2), lineWidth: 1)
                        )
                )

            Text("You are always in control. Whenever you feel rushed, simply press end and dial the safe customer number printed right on the back of your plastic bank card.")
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color(hex: "7C4A00"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(SGSpacing.md)
        .background(Color.silverWarningContainer)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverWarning.opacity(0.3), lineWidth: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ScenarioBriefingView(scenario: Scenario.featuredScenario, state: PracticeState())
    }
}
