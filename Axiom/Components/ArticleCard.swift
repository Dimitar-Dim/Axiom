import SwiftUI

struct ArticleCard: View {
    let article: Article
    let isPublisherFollowed: Bool
    let onTogglePublisher: () -> Void
    let onSelectTag: (String) -> Void
    var onSelectPublisher: (String) -> Void = { _ in }
    var onTap: () -> Void = {}

    var body: some View {
        Button { onTap() } label: { cardContent }
            .buttonStyle(.plain)
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: article.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray5)
                }
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 0) {
                    Text(article.headline)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineSpacing(2)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                    Spacer(minLength: 4)

                    Button { onSelectPublisher(article.publisher) } label: {
                        HStack(spacing: 5) {
                            let theme = PublisherTheme.of(article.publisher)
                            Circle()
                                .fill(theme.color)
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Text(String(theme.initials.prefix(1)))
                                        .font(.system(size: 7, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                            Text(article.publisher)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                            Text("·")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(article.publishedAt)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .fixedSize()
                        }
                    }
                    .buttonStyle(.plain)
                }
                .frame(height: 88)
            }

            HStack(spacing: 8) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        onTogglePublisher()
                    }
                } label: {
                    Image(systemName: isPublisherFollowed ? "heart.fill" : "heart")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(isPublisherFollowed ? Color.red : Color.primary)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(article.tags, id: \.self) { tag in
                            Button { onSelectTag(tag) } label: {
                                Text(tag)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .overlay(Capsule().stroke(Color(.systemGray3), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }
}
