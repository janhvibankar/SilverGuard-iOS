import SwiftUI

// MARK: - Scenario Card
struct ScenarioCard: View {
    let scenario: Scenario
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category label
            Text(scenario.category)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(categoryColor)
                .padding(.bottom, 6)

            // Icon + Title row
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: scenario.iconBackground))
                        .frame(width: 52, height: 52)
                    Image(systemName: scenario.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: scenario.iconColor))
                }

                Text(scenario.title)
                    .font(SilverGuardTypography.headlineMD)
                    .foregroundColor(Color.silverText)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
            .padding(.bottom, 10)

            // Description
            Text(scenario.description)
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverSecondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 12)

            // Meta tags row
            HStack(spacing: 10) {
                MetaTag(icon: "clock", text: "\(scenario.difficulty.rawValue) • \(scenario.durationMinutes) min")

                switch scenario.status {
                case .recommendedNext:
                    MetaTag(icon: "star.fill", text: "Recommended Next", foreground: Color(hex: "7C4A00"), background: Color(hex: "FFF3E0"))
                case .completed(let pts):
                    MetaTag(icon: "checkmark.circle.fill", text: "Completed (+\(pts) pts)", foreground: Color.silverSafe, background: Color.silverSafeContainer)
                case .unattempted:
                    MetaTag(icon: "circle", text: "Unattempted", foreground: Color.silverSecondaryText, background: Color.silverSurfaceHigh)
                }
            }
            .padding(.bottom, 14)

            // CTA button
            switch scenario.status {
            case .completed:
                SecondaryButton(title: "Practice Again", systemImage: "arrow.clockwise", action: onStart)
            default:
                PrimaryButton(title: "Start Practice →", action: onStart)
            }
        }
        .padding(SGSpacing.md)
        .background(Color.silverSurface)
        .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                .stroke(Color.silverBorder, lineWidth: 2)
        )
        .silverCardShadow()
        .accessibilityElement(children: .contain)
    }

    private var categoryColor: Color {
        switch scenario.category {
        case let c where c.contains("URGENCY") || c.contains("GOVERNMENT"):
            return Color.silverDanger
        default:
            return Color.silverPrimaryContainer
        }
    }
}

// MARK: - Tiny Meta Tag
struct MetaTag: View {
    let icon: String
    let text: String
    var foreground: Color = Color.silverSecondaryText
    var background: Color = Color.silverSurfaceHigh

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
            Text(text)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(foreground)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(background)
        )
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(Scenario.mockScenarios) { s in
                ScenarioCard(scenario: s) {}
            }
        }
        .padding()
    }
    .background(Color.silverBackground)
}
