import SwiftUI

enum AppTab {
    case explore, home, favorites
}

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showProfile = false
    @State private var searchText = ""
    @State private var followedTopics: [FollowedTopic] = []
    @State private var followedPublishers: [FollowedPublisher] = []

    var body: some View {
        ZStack(alignment: .top) {
            Group {
                switch selectedTab {
                case .explore:
                    ExploreView(followedPublishers: $followedPublishers, followedTopics: $followedTopics, searchText: $searchText)
                case .home:
                    HomeView(followedPublishers: $followedPublishers, followedTopics: $followedTopics, searchText: $searchText)
                case .favorites:
                    FavoritesView(
                        followedPublishers: $followedPublishers,
                        followedTopics: $followedTopics,
                        searchText: $searchText
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            TopHeaderView(showProfile: $showProfile, searchText: $searchText)

            VStack {
                Spacer()
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .sheet(isPresented: $showProfile) {
            ProfileView(topics: $followedTopics, publishers: $followedPublishers)
        }
    }
}

#Preview {
    ContentView()
}
