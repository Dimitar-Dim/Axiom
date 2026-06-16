import SwiftUI

struct FavoritesView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @Binding var searchText: String
    @Binding var readHistory: [Article]

    @EnvironmentObject var profile: UserInterestProfile
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20
    @State private var activeTagFilter: String? = nil
    @State private var activePublisherFilter: String? = nil

    private let articles = Article.samples

    private var followedArticles: [Article] {
        let publisherNames = Set(followedPublishers.map(\.name))
        let topicTags = Set(followedTopics.map(\.tag))
        return articles.filter { article in
            publisherNames.contains(article.publisher) ||
            article.tags.contains(where: { topicTags.contains($0) })
        }
    }

    private var allFilteredArticles: [Article] {
        var result = followedArticles
        if let tag = activeTagFilter {
            result = result.filter { $0.tags.contains(tag) }
        }
        if let publisher = activePublisherFilter {
            result = result.filter { $0.publisher == publisher }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.headline.lowercased().contains(q) ||
                $0.publisher.lowercased().contains(q) ||
                $0.tags.contains(where: { $0.lowercased().contains(q) })
            }
        }
        return result
    }

    private var filteredArticles: [Article] { Array(allFilteredArticles.prefix(displayCount)) }
    private var hasMore: Bool { displayCount < allFilteredArticles.count }
    private var hasNoFollows: Bool { followedPublishers.isEmpty && followedTopics.isEmpty }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }
    private func isTopicFollowed(_ tag: String) -> Bool {
        followedTopics.contains(where: { $0.tag == tag })
    }
    private func recordRead(_ article: Article) {
        readHistory.removeAll { $0.id == article.id }
        readHistory.insert(article, at: 0)
        profile.record(.articleOpened(article: article))
    }
    private func togglePublisher(_ publisher: String) {
        if let i = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: i)
            profile.record(.publisherUnfollowed(name: publisher))
        } else {
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: 0))
            profile.record(.publisherFollowed(name: publisher))
        }
    }
    private func followTopic(_ tag: String) {
        guard !isTopicFollowed(tag) else { return }
        followedTopics.append(FollowedTopic(name: tag, tag: tag, articleCount: 0))
        profile.record(.topicFollowed(tag: tag))
    }

    var body: some View {
        Group {
            if hasNoFollows {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "heart")
                        .font(.system(size: 48, weight: .thin)).foregroundStyle(.secondary)
                    Text("Nothing here yet")
                        .font(.title2.bold()).foregroundStyle(.secondary)
                    Text("Follow topics or publishers to see their posts here!")
                        .font(.subheadline).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 40)
                    Spacer()
                }
            } else if allFilteredArticles.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48, weight: .thin)).foregroundStyle(.secondary)
                    Text("No results")
                        .font(.title2.bold()).foregroundStyle(.secondary)
                    Text("Try adjusting your filters or search.")
                        .font(.subheadline).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center).padding(.horizontal, 40)
                    if activeTagFilter != nil || activePublisherFilter != nil {
                        Button {
                            withAnimation { activeTagFilter = nil; activePublisherFilter = nil }
                        } label: {
                            Text("Clear filter")
                                .font(.subheadline.bold()).foregroundStyle(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.accentColor).clipShape(Capsule())
                        }
                        .buttonStyle(.plain).padding(.top, 4)
                    }
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if let tag = activeTagFilter       { tagBanner(for: tag) }
                        if let pub = activePublisherFilter { publisherBanner(for: pub) }

                        ForEach(filteredArticles) { article in
                            ArticleCard(
                                article: article,
                                isPublisherFollowed: isPublisherFollowed(article.publisher),
                                onTogglePublisher: { togglePublisher(article.publisher) },
                                onSelectTag: { tag in
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        activeTagFilter = activeTagFilter == tag ? nil : tag
                                        displayCount = 20
                                    }
                                },
                                onSelectPublisher: { pub in
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        activePublisherFilter = activePublisherFilter == pub ? nil : pub
                                        displayCount = 20
                                    }
                                },
                                onTap: { recordRead(article); selectedArticle = article }
                            )
                            .onAppear {
                                if article.id == filteredArticles.last?.id && hasMore { displayCount += 10 }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
                .safeAreaInset(edge: .top) { Color.clear.frame(height: 114) }
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(
                article: article,
                isPublisherFollowed: isPublisherFollowed(article.publisher),
                onTogglePublisher: { togglePublisher(article.publisher) },
                onSelectTag: { tag in
                    selectedArticle = nil
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activeTagFilter = tag; displayCount = 20
                    }
                },
                onSelectPublisher: { pub in
                    selectedArticle = nil
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activePublisherFilter = activePublisherFilter == pub ? nil : pub
                        displayCount = 20
                    }
                },
                onEngagement: { fraction, seconds in
                    profile.record(.articleRead(article: article, readFraction: fraction, timeSpent: seconds))
                }
            )
            .presentationDragIndicator(.visible)
        }
        .onChange(of: searchText)            { displayCount = 20 }
        .onChange(of: activeTagFilter)       { if let tag = $1 { activePublisherFilter = nil; profile.record(.tagFiltered(tag: tag)) } }
        .onChange(of: activePublisherFilter) { if let pub = $1 { activeTagFilter = nil; profile.record(.publisherFiltered(name: pub)) } }
    }

    // MARK: – Banners

    @ViewBuilder
    private func tagBanner(for tag: String) -> some View {
        let followed = isTopicFollowed(tag)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tag)
                    .font(.caption.bold()).foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1)).clipShape(Capsule())
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { activeTagFilter = nil }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color(.systemGray3)).font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
            if followed {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").font(.subheadline).foregroundStyle(.green)
                    Text("You're following \(tag)").font(.subheadline).foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text("Interested in \(tag)?").font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Button { withAnimation { followTopic(tag) } } label: {
                        Text("Follow topic").font(.subheadline.bold()).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(Color.accentColor).clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }

    @ViewBuilder
    private func publisherBanner(for publisher: String) -> some View {
        let theme = PublisherTheme.of(publisher)
        let followed = isPublisherFollowed(publisher)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    ZStack {
                        Circle().fill(theme.color).frame(width: 16, height: 16)
                        Text(String(theme.initials.prefix(1))).font(.system(size: 8, weight: .bold)).foregroundStyle(.white)
                    }
                    Text(publisher).font(.caption.bold()).foregroundStyle(theme.color)
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(theme.color.opacity(0.1)).clipShape(Capsule())
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { activePublisherFilter = nil }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color(.systemGray3)).font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
            if followed {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").font(.subheadline).foregroundStyle(.green)
                    Text("You're following \(publisher)").font(.subheadline).foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text("Follow \(publisher)?").font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Button { withAnimation { togglePublisher(publisher) } } label: {
                        Text("Follow").font(.subheadline.bold()).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(Color.accentColor).clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }
}
