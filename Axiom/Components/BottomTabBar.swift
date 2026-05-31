import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            TabBarButton(icon: "globe.americas", selectedIcon: "globe.americas.fill", tab: .explore, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "house", selectedIcon: "house.fill", tab: .home, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "heart", selectedIcon: "heart.fill", tab: .favorites, selectedTab: $selectedTab)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: -2)
    }
}

struct TabBarButton: View {
    let icon: String
    let selectedIcon: String
    let tab: AppTab
    @Binding var selectedTab: AppTab

    var isSelected: Bool { selectedTab == tab }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: isSelected ? selectedIcon : icon)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 56, height: 40)
                .background(
                    isSelected ? Color(.systemGray5) : Color.clear,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }
}
