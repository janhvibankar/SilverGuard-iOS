import SwiftUI

// MARK: - Circular Trust Score Gauge
struct TrustScoreView: View {
    let score: Int
    var diameter: CGFloat = 160
    var strokeWidth: CGFloat = 12

    private var progress: CGFloat { CGFloat(score) / 100 }

    private var scoreColor: Color {
        switch score {
        case 0..<50:   return .silverDanger
        case 50..<75:  return .silverWarning
        default:       return .silverSafe
        }
    }

    private var scoreLabel: String {
        switch score {
        case 0..<50:   return "AT RISK"
        case 50..<75:  return "LEARNING"
        default:       return "SAFE • ACTIVE"
        }
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.silverBorder, lineWidth: strokeWidth)
                .frame(width: diameter, height: diameter)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(scoreColor,
                        style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .frame(width: diameter, height: diameter)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: progress)

            // Center content
            VStack(spacing: 2) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(score)")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(Color.silverText)
                    Text("/ 100")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.silverSecondaryText)
                }
                Text(scoreLabel)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(scoreColor)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityLabel("Trust score \(score) out of 100, \(scoreLabel)")
    }
}

// MARK: - Preview
struct TrustScoreView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            TrustScoreView(score: 72)
            TrustScoreView(score: 45)
            TrustScoreView(score: 25)
        }
        .padding()
        .background(Color.silverBackground)
    }
}
