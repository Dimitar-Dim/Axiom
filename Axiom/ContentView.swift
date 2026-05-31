import SwiftUI

enum AppTab {
    case explore, home, favorites
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showProfile = false

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch selectedTab {
                case .explore:
                    PlaceholderView(title: "Explore")
                case .home:
                    HomeView()
                case .favorites:
                    PlaceholderView(title: "Favorites")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            TopHeaderView(showProfile: $showProfile)

            VStack {
                Spacer()
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
    }
}

#Preview {
    ContentView()
}
