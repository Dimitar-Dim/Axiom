import SwiftUI

struct FavoritesView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20

    private let articles = Article.samples

    private var allFilteredArticles: [Article] {
        let publisherNames = Set(followedPublishers.map(\.name))
        let topicTags = Set(followedTopics.map(\.tag))
        return articles.filter { article in
            publisherNames.contains(article.publisher) ||
            article.tags.contains(where: { topicTags.contains($0) })
        }
    }

    private var filteredArticles: [Article] {
        Array(allFilteredArticles.prefix(displayCount))
    }

    private var hasMore: Bool { displayCount < allFilteredArticles.count }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }

    private func togglePublisher(_ publisher: String) {
        if let index = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: index)
        } else {
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: 0))
        }
    }

    var body: some View {
        if filteredArticles.isEmpty {
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
        } else {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(filteredArticles) { article in
                        ArticleCard(
                            article: article,
                            isPublisherFollowed: isPublisherFollowed(article.publisher),
                            onTogglePublisher: { togglePublisher(article.publisher) },
                            onSelectTag: { _ in },
                            onTap: { selectedArticle = article }
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
}
