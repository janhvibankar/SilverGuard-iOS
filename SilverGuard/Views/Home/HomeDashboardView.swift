import SwiftUI

struct HomeDashboardView: View {
    @ObservedObject var state: PracticeState
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SGSpacing.md) {

                    // ─── Greeting ─────────────────────────────────────
                    GreetingRow()
                        .padding(.top, 4)

                    // ─── Trust Score Card ──────────────────────────────
                    TrustScoreCard(state: state)

                    // ─── Today's Practice Card ─────────────────────────
                    TodaysPracticeCard(scenario: Scenario.featuredScenario,
                                       onStart: { selectedTab = 1 })

                    // ─── Stats Row ─────────────────────────────────────
                    StatsRow(state: state)

                    // ─── Safety Badges ─────────────────────────────────
                    SectionHeader(title: "Your Safety Badges",
                                  trailingText: "\(state.badgesEarned) of \(state.totalBadges)")

                    BadgesList(badges: state.badges)

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.bottom, 100) // clear tab bar
            }
            .background(Color.silverBackground.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color.silverPrimaryContainer)
                        Text("Home")
                            .font(SilverGuardTypography.headlineMD)
                            .foregroundColor(Color.silverPrimaryContainer)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 14) {
                        Button {
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color.silverText)
                        }
                        .frame(width: 44, height: 44)
                        .accessibilityLabel("Settings")

                        ZStack {
                            Circle()
                                .fill(Color.silverPrimaryContainer)
                                .frame(width: 36, height: 36)
                            Image(systemName: "person.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 44)
                        .accessibilityLabel("Profile")
                    }
                }
            }
        }
    }
}

// MARK: - Greeting Row
private struct GreetingRow: View {
    private var greeting: String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 12 { return "Good morning," }
        if h < 17 { return "Good afternoon," }
        return "Good evening,"
    }
    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d"
        return f.string(from: Date())
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(SilverGuardTypography.headlineLG)
                    .foregroundColor(Color.silverText)
                Text("Margaret")
                    .font(SilverGuardTypography.headlineLG)
                    .foregroundColor(Color.silverText)
                Text("\(dateString) • Let's keep your accounts safe")
                    .font(SilverGuardTypography.bodyLG)
                    .foregroundColor(Color.silverSecondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Text("👋")
                .font(.system(size: 36))
                .accessibilityHidden(true)
        }
    }
}

// MARK: - Trust Score Card
private struct TrustScoreCard: View {
    @ObservedObject var state: PracticeState

    var body: some View {
        VStack(spacing: 14) {
            TrustScoreView(score: state.trustScore, diameter: 160)

            Text("Your Trust Score")
                .font(SilverGuardTypography.headlineMD)
                .foregroundColor(Color.silverPrimaryContainer)

            // Trend badge
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .bold))
                Text("+4 points this week")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(Color.silverSafe)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.silverSafeContainer))

            Text("You are doing wonderful. **\(state.scamsAvoided) scams avoided** so far!")
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverSecondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .silverCard()
    }
}

// MARK: - Today's Practice Card
private struct TodaysPracticeCard: View {
    let scenario: Scenario
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header strip
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    VStack(alignment: .leading, spacing: 0) {
                        Text("TODAY'S")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                        Text("PRACTICE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.silverPrimaryContainer)
                )

                Spacer()

                Text("Step 1 of 1")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.silverSecondaryText)
            }
            .padding(.bottom, 12)

            // Title
            Text(scenario.title)
                .font(SilverGuardTypography.headlineLG)
                .foregroundColor(Color.silverText)
                .padding(.bottom, 10)

            // Tags
            HStack(spacing: 8) {
                MetaTag(icon: "phone.fill",
                        text: scenario.format.rawValue,
                        foreground: Color.silverPrimaryContainer,
                        background: Color.silverSurfaceHigh)
                MetaTag(icon: "clock",
                        text: "~\(scenario.durationMinutes) minutes",
                        foreground: Color.silverSecondaryText,
                        background: Color.silverSurfaceHigh)
            }
            .padding(.bottom, 12)

            // Description
            Text(scenario.description)
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverSecondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 16)

            // CTA
            PrimaryButton(title: "Start Practice  →", action: onStart)
        }
        .padding(SGSpacing.md)
        .background(Color.silverPracticeBackground)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverBorder, lineWidth: 2)
        )
        .silverCardShadow()
    }
}

// MARK: - Stats Row
private struct StatsRow: View {
    @ObservedObject var state: PracticeState

    var body: some View {
        HStack {
            StatCell(icon: "checkmark.circle.fill",
                     iconColor: Color.silverSafe,
                     iconBackground: Color.silverSafeContainer,
                     value: "\(state.scenariosCompleted)",
                     label: "Scenarios")
            Divider().frame(height: 50)
            StatCell(icon: "flame.fill",
                     iconColor: Color.silverWarning,
                     iconBackground: Color.silverWarningContainer,
                     value: "\(state.dayStreak)",
                     label: "Day Streak")
            Divider().frame(height: 50)
            StatCell(icon: "trophy.fill",
                     iconColor: Color.silverPrimaryContainer,
                     iconBackground: Color.silverPracticeBackground,
                     value: "\(state.badgesEarned)",
                     label: "Badges")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, SGSpacing.md)
        .background(Color.silverSurface)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverBorder, lineWidth: 2)
        )
        .silverCardShadow()
    }
}

private struct StatCell: View {
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle().fill(iconBackground).frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(iconColor)
            }
            Text(value)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.silverText)
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color.silverSecondaryText)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(label)")
    }
}

// MARK: - Badges List
private struct BadgesList: View {
    let badges: [PracticeState.Badge]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(badges.enumerated()), id: \.element.id) { idx, badge in
                BadgeRow(badge: badge, isLast: idx == badges.count - 1)
            }
        }
        .background(Color.silverSurface)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverBorder, lineWidth: 2)
        )
        .silverCardShadow()
    }
}

private struct BadgeRow: View {
    let badge: PracticeState.Badge
    let isLast: Bool

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: badge.iconBackground))
                    .frame(width: 48, height: 48)
                Image(systemName: badge.icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: badge.iconColor))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(badge.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color.silverText)
                Text(badge.subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.silverSecondaryText)
            }

            Spacer()

            if badge.isEarned {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.silverSafe)
                    .accessibilityLabel("Earned")
            } else {
                Text("Next up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.silverSecondaryText)
            }
        }
        .padding(.horizontal, SGSpacing.md)
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(Color.silverBorder)
                    .frame(height: 1)
                    .padding(.leading, SGSpacing.md + 48 + 14)
            }
        }
        .opacity(badge.isEarned ? 1.0 : 0.6)
    }
}

// MARK: - Preview
struct HomeDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDashboardView(state: PracticeState(), selectedTab: .constant(0))
    }
}
