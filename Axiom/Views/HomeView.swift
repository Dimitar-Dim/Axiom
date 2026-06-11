import SwiftUI

struct HomeView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @State private var activeTagFilter: String? = nil

    private let articles = Article.samples

    private var displayedArticles: [Article] {
        guard let tag = activeTagFilter else { return articles }
        return articles.filter { $0.tags.contains(tag) }
    }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }

    private func isTopicFollowed(_ tag: String) -> Bool {
        followedTopics.contains(where: { $0.tag == tag })
    }

    private func togglePublisher(_ publisher: String) {
        if let index = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: index)
        } else {
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: 0))
        }
    }

    private func followTopic(_ tag: String) {
        guard !isTopicFollowed(tag) else { return }
        followedTopics.append(FollowedTopic(name: tag, tag: tag, articleCount: 0))
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if let tag = activeTagFilter {
                    filterBanner(for: tag)
                }
                ForEach(displayedArticles) { article in
                    ArticleCard(
                        article: article,
                        isPublisherFollowed: isPublisherFollowed(article.publisher),
                        onTogglePublisher: { togglePublisher(article.publisher) },
                        onSelectTag: { tag in
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                activeTagFilter = activeTagFilter == tag ? nil : tag
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 110)
        }
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 114) }
    }

    @ViewBuilder
    private func filterBanner(for tag: String) -> some View {
        let followed = isTopicFollowed(tag)

        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tag)
                    .font(.caption.bold())
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activeTagFilter = nil
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(.systemGray3))
                        .font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }

            if followed {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                    Text("You're following \(tag)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text("Interested in \(tag)?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button {
                        withAnimation { followTopic(tag) }
                    } label: {
                        Text("Follow topic")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
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
