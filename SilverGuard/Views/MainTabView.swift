import SwiftUI

struct MainTabView: View {
    @StateObject private var practiceState = PracticeState()
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeDashboardView(state: practiceState, selectedTab: $selectedTab)
                    .tag(0)

                ScenarioSelectionView(state: practiceState)
                    .tag(1)

                ScamCheckView()
                    .tag(2)

                FamilyView()
                    .tag(3)
            }
            // Hide the default iOS tab bar — we use our own
            .tabViewStyle(DefaultTabViewStyle())
            .toolbar(.hidden, for: .tabBar)

            // ─── Custom Bottom Tab Bar ────────────────────────────────
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, selectedIcon: String, label: String)] = [
        ("house",        "house.fill",          "Home"),
        ("graduationcap","graduationcap.fill",   "Practice"),
        ("shield",       "shield.fill",          "Scam Check"),
        ("person.2",     "person.2.fill",        "Family")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { idx, tab in
                TabBarItem(
                    icon: tab.icon,
                    selectedIcon: tab.selectedIcon,
                    label: tab.label,
                    isSelected: selectedTab == idx,
                    action: { selectedTab = idx }
                )
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 0)
        .frame(height: 84)
        .background(
            Color.silverSurface
                .ignoresSafeArea(edges: .bottom)
                .overlay(
                    Rectangle()
                        .fill(Color.silverBorder)
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }
}

// MARK: - Individual Tab Item
private struct TabBarItem: View {
    let icon: String
    let selectedIcon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                // Active indicator line
                Rectangle()
                    .fill(isSelected ? Color.silverPrimaryContainer : Color.clear)
                    .frame(height: 3)
                    .frame(maxWidth: .infinity)
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)

                Spacer()

                Image(systemName: isSelected ? selectedIcon : icon)
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color.silverPrimaryContainer : Color.silverSecondaryText)

                Text(label)
                    .font(SilverGuardTypography.labelNavigation)
                    .foregroundColor(isSelected ? Color.silverPrimaryContainer : Color.silverSecondaryText)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(label)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
