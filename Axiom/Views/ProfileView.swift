import SwiftUI

private struct SearchResult: Identifiable {
    let id: UUID
    let name: String
    let isTopic: Bool
}

struct ProfileView: View {
    @Binding var topics: [FollowedTopic]
    @Binding var publishers: [FollowedPublisher]
    @Binding var readHistory: [Article]
    @EnvironmentObject var profile: UserInterestProfile
    @State private var topicsExpanded = false
    @State private var publishersExpanded = false
    @State private var historyExpanded = false
    @State private var selectedArticle: Article? = nil
    @State private var searchText = ""

    private var searchResults: [SearchResult] {
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !query.isEmpty else { return [] }

        let matchedTopics = topics
            .filter { $0.name.lowercased().contains(query) }
            .map { SearchResult(id: $0.id, name: $0.name, isTopic: true) }

        let matchedPublishers = publishers
            .filter { $0.name.lowercased().contains(query) }
            .map { SearchResult(id: $0.id, name: $0.name, isTopic: false) }

        return matchedTopics + matchedPublishers
    }

    private var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Account")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)
            .background(Color(.systemBackground))

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 15))
                TextField("Search topics and publishers", text: $searchText)
                    .font(.system(size: 16))
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 15))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .background(Color(.systemBackground))

            ScrollView {
                VStack(spacing: 14) {
                    if isSearching {
                        if searchResults.isEmpty {
                            Text("No results")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.top, 40)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(searchResults) { result in
                                    SearchResultRow(result: result) {
                                        withAnimation {
                                            if result.isTopic {
                                                topics.removeAll { $0.id == result.id }
                                                profile.record(.topicUnfollowed(tag: result.name))
                                            } else {
                                                publishers.removeAll { $0.id == result.id }
                                                profile.record(.publisherUnfollowed(name: result.name))
                                            }
                                        }
                                    }
                                    if result.id != searchResults.last?.id {
                                        Divider().padding(.horizontal, 16)
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
                        }
                    } else {
                        followSection(
                            title: "Topics I Follow",
                            count: topics.count,
                            expanded: $topicsExpanded
                        ) {
                            ForEach(topics) { topic in
                                TopicRow(name: topic.name) {
                                    withAnimation {
                                        topics.removeAll { $0.id == topic.id }
                                        profile.record(.topicUnfollowed(tag: topic.tag))
                                    }
                                }
                                if topic.id != topics.last?.id {
                                    Divider().padding(.horizontal, 16)
                                }
                            }
                        }

                        followSection(
                            title: "Publishers I Follow",
                            count: publishers.count,
                            expanded: $publishersExpanded
                        ) {
                            ForEach(publishers) { publisher in
                                TopicRow(name: publisher.name) {
                                    withAnimation {
                                        publishers.removeAll { $0.id == publisher.id }
                                        profile.record(.publisherUnfollowed(name: publisher.name))
                                    }
                                }
                                if publisher.id != publishers.last?.id {
                                    Divider().padding(.horizontal, 16)
                                }
                            }
                        }

                        if topics.isEmpty && publishers.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 40, weight: .thin))
                                    .foregroundStyle(.secondary)
                                Text("Nothing followed yet")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 40)
                        }

                        historySection

                        VStack(spacing: 0) {
                            navRow(icon: "slider.horizontal.3", label: "Preferences")
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(
                article: article,
                isPublisherFollowed: publishers.contains(where: { $0.name == article.publisher }),
                onTogglePublisher: {
                    if let i = publishers.firstIndex(where: { $0.name == article.publisher }) {
                        publishers.remove(at: i)
                        profile.record(.publisherUnfollowed(name: article.publisher))
                    } else {
                        publishers.append(FollowedPublisher(name: article.publisher, articleCount: 0))
                        profile.record(.publisherFollowed(name: article.publisher))
                    }
                },
                onSelectTag: { _ in },
                onEngagement: { fraction, seconds in
                    profile.record(.articleRead(article: article, readFraction: fraction, timeSpent: seconds))
                }
            )
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    private var historySection: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    historyExpanded.toggle()
                }
            } label: {
                HStack {
                    Text("History")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    if !readHistory.isEmpty {
                        Text("\(readHistory.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.trailing, 4)
                    }
                    Image(systemName: readHistory.isEmpty ? "clock" : "chevron.down")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(historyExpanded ? 0 : -90))
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: historyExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .disabled(readHistory.isEmpty)

            if historyExpanded && !readHistory.isEmpty {
                Divider().padding(.horizontal, 16)
                ForEach(readHistory) { article in
                    HistoryRow(article: article) {
                        selectedArticle = article
                    }
                    if article.id != readHistory.last?.id {
                        Divider().padding(.horizontal, 16)
                    }
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }

    private func navRow(icon: String, label: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private func followSection<Rows: View>(
        title: String,
        count: Int,
        expanded: Binding<Bool>,
        @ViewBuilder rows: () -> Rows
    ) -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    expanded.wrappedValue.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.trailing, 4)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(expanded.wrappedValue ? 0 : -90))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .buttonStyle(.plain)

            if expanded.wrappedValue {
                Divider().padding(.horizontal, 16)
                rows()
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }
}

struct TopicRow: View {
    let name: String
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Button(action: onRemove) {
                Text("Remove")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.08), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

private struct HistoryRow: View {
    let article: Article
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                let theme = PublisherTheme.of(article.publisher)
                ZStack {
                    Circle().fill(theme.color).frame(width: 34, height: 34)
                    Text(theme.initials)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(article.headline)
                        .font(.subheadline.weight(.medium))
                        .lineLimit(2)
                        .foregroundStyle(.primary)
                    Text(article.publisher + " · " + article.publishedAt)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

private struct SearchResultRow: View {
    let result: SearchResult
    let onRemove: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(result.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(result.isTopic ? "Topic" : "Publisher")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onRemove) {
                Text("Remove")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.08), in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
