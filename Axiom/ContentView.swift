import SwiftUI

enum AppTab {
    case explore, home, favorites
}

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var profile = UserInterestProfile()
    @State private var selectedTab: AppTab = .home
    @State private var showProfile = false
    @State private var searchText = ""
    @State private var followedTopics: [FollowedTopic] = ContentView.loadFollowedTopics()
    @State private var followedPublishers: [FollowedPublisher] = ContentView.loadFollowedPublishers()
    @State private var readHistory: [Article] = ContentView.loadReadHistory()
    // NewsAPI is detached — pool is permanently the hardcoded local sample set.
    @State private var articles: [Article] = Article.samples

    @ViewBuilder private var exploreTab: some View {
        ExploreView(
            articles: articles,
            onRegionChange: { _ in },
            followedPublishers: $followedPublishers,
            followedTopics: $followedTopics,
            searchText: $searchText,
            readHistory: $readHistory
        )
    }

    @ViewBuilder private var homeTab: some View {
        HomeView(
            articles: articles,
            onRefresh: { },
            followedPublishers: $followedPublishers,
            followedTopics: $followedTopics,
            searchText: $searchText,
            readHistory: $readHistory
        )
    }

    @ViewBuilder private var favoritesTab: some View {
        FavoritesView(
            articles: articles,
            onEnsureArticles: { },
            followedPublishers: $followedPublishers,
            followedTopics: $followedTopics,
            searchText: $searchText,
            readHistory: $readHistory
        )
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .explore:   exploreTab
        case .home:      homeTab
        case .favorites: favoritesTab
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            TopHeaderView(showProfile: $showProfile, searchText: $searchText)

            VStack {
                Spacer()
                BottomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(profile)
        .onChange(of: followedTopics)     { _, new in Self.persist(new, key: "axiom_followedTopics") }
        .onChange(of: followedPublishers) { _, new in Self.persist(new, key: "axiom_followedPublishers") }
        .onChange(of: readHistory)        { _, new in Self.persistReadHistory(new) }
        .fullScreenCover(isPresented: Binding(
            get: { !hasCompletedOnboarding },
            set: { _ in }
        )) {
            OnboardingView { selectedTags in
                for tag in selectedTags {
                    followedTopics.append(FollowedTopic(name: tag, tag: tag, articleCount: Article.articleCount(forTag: tag)))
                }
                profile.record(.onboardingSelected(tags: selectedTags))
                hasCompletedOnboarding = true
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(topics: $followedTopics, publishers: $followedPublishers, readHistory: $readHistory)
                .environmentObject(profile)
        }
    }

    // MARK: – Persistence

    private static func persist<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func persistReadHistory(_ articles: [Article]) {
        UserDefaults.standard.set(articles.map(\.headline), forKey: "axiom_readHistoryHeadlines")
    }

    private static func loadFollowedTopics() -> [FollowedTopic] {
        guard let data = UserDefaults.standard.data(forKey: "axiom_followedTopics"),
              let decoded = try? JSONDecoder().decode([FollowedTopic].self, from: data) else { return [] }
        return decoded
    }

    private static func loadFollowedPublishers() -> [FollowedPublisher] {
        guard let data = UserDefaults.standard.data(forKey: "axiom_followedPublishers"),
              let decoded = try? JSONDecoder().decode([FollowedPublisher].self, from: data) else { return [] }
        return decoded
    }

    private static func loadReadHistory() -> [Article] {
        guard let headlines = UserDefaults.standard.stringArray(forKey: "axiom_readHistoryHeadlines") else { return [] }
        return headlines.compactMap { headline in Article.samples.first { $0.headline == headline } }
    }
}

#Preview {
    ContentView()
}
