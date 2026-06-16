import SwiftUI

struct HomeView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @Binding var searchText: String
    @Binding var readHistory: [Article]
    @State private var activeTagFilter: String? = nil
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20

    private let articles = Article.samples

    private var filteredArticles: [Article] {
        var result = articles
        if let tag = activeTagFilter {
            result = result.filter { $0.tags.contains(tag) }
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

    private var displayedArticles: [Article] {
        Array(filteredArticles.prefix(displayCount))
    }

    private var hasMore: Bool { displayCount < filteredArticles.count }

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

    private func recordRead(_ article: Article) {
        readHistory.removeAll { $0.id == article.id }
        readHistory.insert(article, at: 0)
    }

    private func followTopic(_ tag: String) {
        guard !isTopicFollowed(tag) else { return }
        followedTopics.append(FollowedTopic(name: tag, tag: tag, articleCount: 0))
    }

    var body: some View {
        Group {
            if displayedArticles.isEmpty && !searchText.isEmpty {
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
                                displayCount = 20
                            }
                        },
                        onTap: { recordRead(article); selectedArticle = article }
                    )
                    .onAppear {
                        if article.id == displayedArticles.last?.id && hasMore {
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
                onSelectTag: { tag in
                    selectedArticle = nil
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activeTagFilter = tag
                    }
                }
            )
            .presentationDragIndicator(.visible)
        }
        } // end else
        }  // end Group
        .onChange(of: searchText) { displayCount = 20 }
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
