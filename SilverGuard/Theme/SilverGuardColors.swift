import SwiftUI

// MARK: - Hex colour initialiser
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:     Double(r) / 255,
                  green:   Double(g) / 255,
                  blue:    Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - SilverGuard Design-System Colours
extension Color {
    // Background / Canvas
    static let silverBackground   = Color(hex: "FCF9F8")
    static let silverSurface      = Color(hex: "FFFFFF")
    static let silverSurfaceLow   = Color(hex: "F6F3F2")
    static let silverSurfaceHigh  = Color(hex: "EAE7E7")

    // Brand
    static let silverPrimary          = Color(hex: "00263F")
    static let silverPrimaryContainer = Color(hex: "0B3C5D")

    // Text hierarchy
    static let silverText          = Color(hex: "1C1B1B")
    static let silverSecondaryText = Color(hex: "42474E")

    // Borders / outlines
    static let silverBorder  = Color(hex: "E2DDD5")
    static let silverOutline = Color(hex: "C2C7CE")

    // Semantic states
    static let silverSafe    = Color(hex: "1B7F3B")
    static let silverWarning = Color(hex: "B26A00")
    static let silverDanger  = Color(hex: "B3261E")

    // Semantic containers (light tinted backgrounds)
    static let silverSafeContainer    = Color(hex: "E8F5EC")
    static let silverWarningContainer = Color(hex: "FFF3E0")
    static let silverDangerContainer  = Color(hex: "FFDAD6")

    // Practice card accent
    static let silverPracticeBackground = Color(hex: "EEF4FB")
}
