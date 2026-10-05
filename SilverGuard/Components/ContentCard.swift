import SwiftUI

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var trailingText: String? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SilverGuardTypography.headlineMD)
                    .foregroundColor(Color.silverText)
                if let sub = subtitle {
                    Text(sub)
                        .font(SilverGuardTypography.bodyLG)
                        .foregroundColor(Color.silverSecondaryText)
                }
            }
            Spacer()
            if let trail = trailingText {
                Text(trail)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.silverSecondaryText)
            }
        }
    }
}

// MARK: - Content Card (generic wrapper)
struct ContentCard<Content: View>: View {
    var padding: CGFloat = SGSpacing.md
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .silverCard(padding: padding)
    }
}

// MARK: - Preview
struct ContentCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            SectionHeader(title: "Your Safety Badges", trailingText: "2 of 12")
            ContentCard {
                Text("Hello, world!")
                    .font(SilverGuardTypography.bodyLG)
            }
        }
        .padding()
        .background(Color.silverBackground)
    }
}
