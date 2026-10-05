import SwiftUI

// MARK: - Typography Scale
struct SilverGuardTypography {
    // Headlines
    static let headlineXL = Font.system(size: 34, weight: .bold, design: .default)
    static let headlineLG = Font.system(size: 28, weight: .bold, design: .default)
    static let headlineMD = Font.system(size: 24, weight: .bold, design: .default)

    // Body
    static let bodyXL = Font.system(size: 22, weight: .medium, design: .default)
    static let bodyLG = Font.system(size: 20, weight: .regular, design: .default)

    // Interactive / Actions
    static let labelAction     = Font.system(size: 22, weight: .semibold, design: .default)
    static let labelNavigation = Font.system(size: 16, weight: .semibold, design: .default)
    static let labelTag        = Font.system(size: 14, weight: .bold, design: .default)
    static let labelSmall      = Font.system(size: 18, weight: .bold, design: .default)

    // Body medium
    static let bodyMD = Font.system(size: 18, weight: .regular, design: .default)
    static let bodySM = Font.system(size: 16, weight: .regular, design: .default)
}
