import SwiftUI

// MARK: - Risk Level Enum
enum RiskLevel: Int, CaseIterable {
    case safe       = 0
    case suspicious = 1
    case highRisk   = 2

    var title: String {
        switch self {
        case .safe:       return "Safe"
        case .suspicious: return "Suspicious"
        case .highRisk:   return "Scam"
        }
    }

    var icon: String {
        switch self {
        case .safe:       return "checkmark.circle.fill"
        case .suspicious: return "exclamationmark.triangle.fill"
        case .highRisk:   return "xmark.octagon.fill"
        }
    }

    var color: Color {
        switch self {
        case .safe:       return .silverSafe
        case .suspicious: return .silverWarning
        case .highRisk:   return .silverDanger
        }
    }
}

// MARK: - Horizontal 3-Tier Risk Meter
struct RiskMeterView: View {
    let currentLevel: RiskLevel
    var percentage: Int = 0
    var description: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Label row
            HStack(alignment: .center, spacing: 8) {
                Text("SCAM\nLIKELIHOOD")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color.silverSecondaryText)
                    .lineLimit(2)
                    .fixedSize()

                Spacer()

                // Active badge
                HStack(spacing: 5) {
                    Image(systemName: currentLevel.icon)
                        .font(.system(size: 14, weight: .bold))
                    Text(percentage > 0 ? "\(percentage)% — Very\nHigh Risk" : "\(currentLevel.title)")
                        .font(.system(size: 14, weight: .bold))
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(currentLevel.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(currentLevel.color.opacity(0.12))
                )
            }

            // Segmented bar
            HStack(spacing: 4) {
                ForEach(RiskLevel.allCases, id: \.rawValue) { level in
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(level.color)
                        .frame(height: level == currentLevel ? 16 : 12)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(level == currentLevel ? level.color : Color.clear, lineWidth: 2)
                        )
                }
            }
            .animation(.easeInOut, value: currentLevel)

            // Labels row
            HStack {
                ForEach(RiskLevel.allCases, id: \.rawValue) { level in
                    HStack(spacing: 4) {
                        Image(systemName: level.icon)
                            .font(.system(size: 11))
                        Text(level.title)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(level == currentLevel ? level.color : Color.silverSecondaryText)
                    .frame(maxWidth: .infinity)
                }
            }

            // Optional pointer dot on bar
            if let dot = dotOffset(for: currentLevel) {
                GeometryReader { geo in
                    Circle()
                        .fill(Color.silverDanger)
                        .frame(width: 14, height: 14)
                        .offset(x: dot * geo.size.width - 7, y: -20)
                }
                .frame(height: 14)
            }
        }
        .accessibilityLabel("Risk level: \(currentLevel.title)")
    }

    private func dotOffset(for level: RiskLevel) -> CGFloat? {
        guard percentage > 0 else { return nil }
        return CGFloat(percentage) / 100
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        RiskMeterView(currentLevel: .safe)
        RiskMeterView(currentLevel: .suspicious)
        RiskMeterView(currentLevel: .highRisk, percentage: 85)
    }
    .padding()
    .background(Color.silverBackground)
}
