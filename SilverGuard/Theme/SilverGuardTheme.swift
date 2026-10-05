import SwiftUI

// MARK: - Spacing & Layout Constants
enum SGSpacing {
    static let gutter:  CGFloat = 20
    static let xs:      CGFloat = 8
    static let sm:      CGFloat = 12
    static let md:      CGFloat = 20
    static let lg:      CGFloat = 28
    static let xl:      CGFloat = 40
}

// MARK: - Corner Radius Constants
enum SGRadius {
    static let sm:   CGFloat = 8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 20
    static let full: CGFloat = 9999
}

// MARK: - Shadow Style
extension View {
    func silverCardShadow() -> some View {
        self.shadow(color: Color(hex: "0B3C5D").opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Card Modifier
struct SilverCardStyle: ViewModifier {
    var padding: CGFloat = SGSpacing.md
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.silverSurface)
            .clipShape(RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: SGRadius.xl, style: .continuous)
                    .stroke(Color.silverBorder, lineWidth: 2)
            )
            .silverCardShadow()
    }
}

extension View {
    func silverCard(padding: CGFloat = SGSpacing.md) -> some View {
        self.modifier(SilverCardStyle(padding: padding))
    }
}
