import SwiftUI

struct ScamCheckView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SGSpacing.md) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Check a Scam")
                            .font(SilverGuardTypography.headlineXL)
                            .foregroundColor(Color.silverText)
                        Text("Paste suspicious text or enter a phone number to instantly check if it's a known scam.")
                            .font(SilverGuardTypography.bodyLG)
                            .foregroundColor(Color.silverSecondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 8)

                    // Input card
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Paste suspicious message or number")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.silverSecondaryText)

                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: SGRadius.lg)
                                .fill(Color.silverSurfaceLow)
                                .frame(height: 140)
                                .overlay(
                                    RoundedRectangle(cornerRadius: SGRadius.lg)
                                        .stroke(Color.silverBorder, lineWidth: 2)
                                )
                            Text("e.g. \"Your account has been suspended…\"")
                                .font(SilverGuardTypography.bodyLG)
                                .foregroundColor(Color.silverBorder)
                                .padding(16)
                        }

                        PrimaryButton(title: "Check This Message", systemImage: "magnifyingglass") {}
                    }
                    .silverCard()

                    // Quick examples
                    SectionHeader(title: "Quick Examples")

                    VStack(spacing: 10) {
                        QuickExampleRow(text: "\"Your Medicare benefits expire soon…\"")
                        QuickExampleRow(text: "\"IRS arrest warrant issued in your name…\"")
                        QuickExampleRow(text: "\"Your grandson is in trouble, please send…\"")
                    }
                    .silverCard()

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
                        Text("Scam Check")
                            .font(SilverGuardTypography.headlineMD)
                            .foregroundColor(Color.silverPrimaryContainer)
                    }
                }
            }
        }
    }
}

private struct QuickExampleRow: View {
    let text: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Color.silverWarning)
                .font(.system(size: 18))
            Text(text)
                .font(SilverGuardTypography.bodyLG)
                .foregroundColor(Color.silverText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.silverOutline)
        }
        .padding(.vertical, 4)
        .frame(minHeight: 48)
    }
}

struct ScamCheckView_Previews: PreviewProvider {
    static var previews: some View {
        ScamCheckView()
    }
}
