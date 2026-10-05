import SwiftUI

struct ScenarioSelectionView: View {
    @ObservedObject var state: PracticeState
    @State private var searchText: String = ""
    @State private var selectedFormat: ScenarioFormat = .phoneCall
    @State private var navigationPath = NavigationPath()

    private var filteredScenarios: [Scenario] {
        Scenario.mockScenarios.filter { s in
            s.format == selectedFormat &&
            (searchText.isEmpty || s.title.localizedCaseInsensitiveContains(searchText)
             || s.description.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: SGSpacing.md) {

                    // ─── Safe simulation badge ─────────────────────────
                    HStack(spacing: 6) {
                        Circle().fill(Color.silverSafe).frame(width: 8, height: 8)
                        Text("100% Safe Simulation")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.silverSafe)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Capsule().fill(Color.silverSafeContainer))

                    // ─── Header ────────────────────────────────────────
                    Text("Choose a Practice")
                        .font(SilverGuardTypography.headlineXL)
                        .foregroundColor(Color.silverText)

                    Text("Pick any scenario to practice safely. Nothing here is real.")
                        .font(SilverGuardTypography.bodyLG)
                        .foregroundColor(Color.silverSecondaryText)
                        .fixedSize(horizontal: false, vertical: true)

                    // ─── Search ────────────────────────────────────────
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.silverSecondaryText)
                        TextField("Search practices (e.g. bank", text: $searchText)
                            .font(SilverGuardTypography.bodyLG)
                            .foregroundColor(Color.silverText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.silverSurface)
                    .clipShape(RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: SGRadius.lg, style: .continuous)
                            .stroke(Color.silverBorder, lineWidth: 2)
                    )

                    // ─── Format Picker ─────────────────────────────────
                    VStack(alignment: .leading, spacing: 10) {
                        Text("FORMAT")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color.silverSecondaryText)
                            .tracking(1.2)

                        HStack(spacing: 10) {
                            FormatTab(title: "Phone Calls (\(phoneCount))",
                                      icon: "phone.fill",
                                      isSelected: selectedFormat == .phoneCall,
                                      action: { selectedFormat = .phoneCall })
                            FormatTab(title: "Text Msg",
                                      icon: "message.fill",
                                      isSelected: selectedFormat == .textMessage,
                                      action: { selectedFormat = .textMessage })
                        }
                    }

                    // ─── Scenario Cards ────────────────────────────────
                    ForEach(filteredScenarios) { scenario in
                        ScenarioCard(scenario: scenario) {
                            state.selectScenario(scenario)
                            navigationPath.append(scenario.id)
                        }
                    }

                    // ─── Help Card ─────────────────────────────────────
                    HelpCard()

                    Spacer(minLength: 20)
                }
                .padding(.horizontal, SGSpacing.gutter)
                .padding(.top, 8)
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
                        Text("Practice")
                            .font(SilverGuardTypography.headlineMD)
                            .foregroundColor(Color.silverPrimaryContainer)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 14) {
                        Button { } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18))
                                .foregroundColor(Color.silverText)
                        }
                        .frame(width: 44, height: 44)

                        ZStack {
                            Circle().fill(Color.silverPrimaryContainer).frame(width: 36, height: 36)
                            Image(systemName: "person.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 44)
                    }
                }
            }
            .navigationDestination(for: UUID.self) { id in
                if let scenario = Scenario.mockScenarios.first(where: { $0.id == id }) {
                    ScenarioBriefingView(scenario: scenario, state: state)
                }
            }
        }
    }

    private var phoneCount: Int {
        Scenario.mockScenarios.filter { $0.format == .phoneCall }.count
    }
}

// MARK: - Format Tab Button
private struct FormatTab: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Color.silverPrimaryContainer)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: SGRadius.full, style: .continuous)
                    .fill(isSelected ? Color.silverPrimaryContainer : Color.silverSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: SGRadius.full, style: .continuous)
                            .stroke(Color.silverBorder, lineWidth: isSelected ? 0 : 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .frame(minHeight: 48)
        .accessibilityLabel("\(title) format, \(isSelected ? "selected" : "not selected")")
    }
}

// MARK: - Help Card
private struct HelpCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle().fill(Color.silverPracticeBackground).frame(width: 44, height: 44)
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.silverPrimaryContainer)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Need help choosing?")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.silverText)
                Text("Tap the recommended practice above. It guides you step-by-step with voice tips.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color.silverSecondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .silverCard()
    }
}

// MARK: - Preview
struct ScenarioSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ScenarioSelectionView(state: PracticeState())
    }
}
