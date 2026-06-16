import SwiftUI

struct FavoritesView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @Binding var searchText: String
    @Binding var readHistory: [Article]
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20

    private let articles = Article.samples

    private var allFilteredArticles: [Article] {
        let publisherNames = Set(followedPublishers.map(\.name))
        let topicTags = Set(followedTopics.map(\.tag))
        var result = articles.filter { article in
            publisherNames.contains(article.publisher) ||
            article.tags.contains(where: { topicTags.contains($0) })
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

    private var filteredArticles: [Article] {
        Array(allFilteredArticles.prefix(displayCount))
    }

    private var hasMore: Bool { displayCount < allFilteredArticles.count }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }

    private func recordRead(_ article: Article) {
        readHistory.removeAll { $0.id == article.id }
        readHistory.insert(article, at: 0)
    }

    private func togglePublisher(_ publisher: String) {
        if let index = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: index)
        } else {
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: 0))
        }
    }

    private var isEmpty: Bool { followedPublishers.isEmpty && followedTopics.isEmpty }

    var body: some View {
        Group {
            if isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "heart")
                        .font(.system(size: 48, weight: .thin))
                        .foregroundStyle(.secondary)
                    Text("Nothing here yet")
                        .font(.title2.bold())
                        .foregroundStyle(.secondary)
                    Text("Follow topics or publishers to see their posts here!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else if filteredArticles.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48, weight: .thin))
                        .foregroundStyle(.secondary)
                    Text("No results for \"\(searchText)\"")
                        .font(.title2.bold())
                        .foregroundStyle(.secondary)
                    Text("Try a different headline, publisher, or topic.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredArticles) { article in
                            ArticleCard(
                                article: article,
                                isPublisherFollowed: isPublisherFollowed(article.publisher),
                                onTogglePublisher: { togglePublisher(article.publisher) },
                                onSelectTag: { _ in },
                                onTap: { recordRead(article); selectedArticle = article }
                            )
                            .onAppear {
                                if article.id == filteredArticles.last?.id && hasMore {
                                    displayCount += 10
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
                .safeAreaInset(edge: .top) { Color.clear.frame(height: 114) }
                .sheet(item: $selectedArticle) { article in
                    ArticleDetailView(
                        article: article,
                        isPublisherFollowed: isPublisherFollowed(article.publisher),
                        onTogglePublisher: { togglePublisher(article.publisher) },
                        onSelectTag: { _ in }
                    )
                    .presentationDragIndicator(.visible)
                }
            }
        }
        .onChange(of: searchText) { displayCount = 20 }
    }
}
