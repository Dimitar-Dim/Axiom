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
    // Pool: starts with hardcoded samples, live articles are merged in as they arrive
    @State private var articles: [Article] = Article.samples
    @State private var searchFetchTask: Task<Void, Never>? = nil

    @ViewBuilder private var exploreTab: some View {
        ExploreView(
            articles: articles,
            onRegionChange: { region in await fetchForRegion(region) },
            followedPublishers: $followedPublishers,
            followedTopics: $followedTopics,
            searchText: $searchText,
            readHistory: $readHistory
        )
    }

    @ViewBuilder private var homeTab: some View {
        HomeView(
            articles: articles,
            onRefresh: { await fetchTopHeadlines() },
            followedPublishers: $followedPublishers,
            followedTopics: $followedTopics,
            searchText: $searchText,
            readHistory: $readHistory
        )
    }

    @ViewBuilder private var favoritesTab: some View {
        FavoritesView(
            articles: articles,
            onEnsureArticles: { await fetchForFollows() },
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
        .task { await fetchTopHeadlines() }
        .ignoresSafeArea(edges: .bottom)
        .environmentObject(profile)
        .onChange(of: searchText) { _, query in
            searchFetchTask?.cancel()
            guard query.count >= 3 else { return }
            searchFetchTask = Task {
                try? await Task.sleep(for: .milliseconds(600))
                guard !Task.isCancelled else { return }
                await fetchForSearch(query)
            }
        }
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

    // MARK: – Fetch

    @MainActor
    private func fetchTopHeadlines() async {
        do {
            let fetched = try await NewsService.topHeadlines()
            articles = await StoryProcessor.process(incoming: fetched, pool: articles)
        } catch { print("topHeadlines error: \(error)") }
    }

    @MainActor
    private func fetchForRegion(_ region: Region) async {
        guard let code = region.newsAPICountryCode else { return }
        do {
            let fetched = try await NewsService.forCountry(code, locationName: region.rawValue)
            articles = await StoryProcessor.process(incoming: fetched, pool: articles)
        } catch { print("region fetch error: \(error)") }
    }

    @MainActor
    private func fetchForSearch(_ query: String) async {
        do {
            let fetched = try await NewsService.forQuery(query)
            articles = await StoryProcessor.process(incoming: fetched, pool: articles)
        } catch { print("search fetch error: \(error)") }
    }

    @MainActor
    private func fetchForFollows() async {
        let terms = (followedTopics.map(\.tag) + followedPublishers.map(\.name))
            .prefix(5)
            .joined(separator: " OR ")
        guard !terms.isEmpty else { return }
        do {
            let fetched = try await NewsService.forQuery(terms)
            articles = await StoryProcessor.process(incoming: fetched, pool: articles)
        } catch { print("follows fetch error: \(error)") }
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
