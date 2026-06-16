import SwiftUI

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}

struct ArticleDetailView: View {
    let article: Article
    let isPublisherFollowed: Bool
    let onTogglePublisher: () -> Void
    let onSelectTag: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var readingProgress: CGFloat = 0
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                AsyncImage(url: URL(string: article.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipped()

                VStack(alignment: .leading, spacing: 20) {
                    publisherRow

                    Text(article.headline)
                        .font(.title2.bold())
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    Text(article.body)
                        .font(.body)
                        .lineSpacing(8)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    tagsSection

                    Color.clear.frame(height: 40)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { contentHeight = geo.size.height }
                        .preference(
                            key: ScrollOffsetKey.self,
                            value: geo.frame(in: .named("scroll")).minY
                        )
                }
            )
        }
        .coordinateSpace(name: "scroll")
        .ignoresSafeArea(edges: .top)
        .onPreferenceChange(ScrollOffsetKey.self) { offset in
            let viewportHeight = UIScreen.main.bounds.height
            let scrollable = contentHeight - viewportHeight
            if scrollable > 0 {
                readingProgress = max(0, min(1, -offset / scrollable))
            }
        }
        .overlay(alignment: .top) {
            GeometryReader { bar in
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color(.systemGray5).opacity(0.5))
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: bar.size.width * readingProgress)
                        .animation(.linear(duration: 0.08), value: readingProgress)
                }
            }
            .frame(height: 3)
        }
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .padding(.leading, 16)
            .padding(.top, 56)
        }
        .presentationDragIndicator(.visible)
    }

    private var publisherRow: some View {
        HStack(spacing: 12) {
            let theme = PublisherTheme.of(article.publisher)
            ZStack {
                Circle().fill(theme.color).frame(width: 40, height: 40)
                Text(theme.initials)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(article.publisher)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Text(article.publishedAt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .layoutPriority(1)

            Spacer(minLength: 8)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    onTogglePublisher()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isPublisherFollowed ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .contentTransition(.symbolEffect(.replace))
                    Text(isPublisherFollowed ? "Following" : "Follow")
                        .font(.subheadline.bold())
                }
                .foregroundStyle(isPublisherFollowed ? Color.red : Color.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isPublisherFollowed ? Color.red.opacity(0.1) : Color.accentColor)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TOPICS")
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
                .tracking(1)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(article.tags, id: \.self) { tag in
                        Button { onSelectTag(tag) } label: {
                            Text(tag)
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 9)
                                .background(Color(.systemGray6))
                                .clipShape(Capsule())
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
