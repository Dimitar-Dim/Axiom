import SwiftUI

struct ArticleCard: View {
    @Binding var article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(width: 88, height: 88)

                    HStack(spacing: 4) {
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
                    }
                }

                Text(article.headline)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineSpacing(2)
                    .lineLimit(4)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            HStack(spacing: 8) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        article.isLiked.toggle()
                    }
                } label: {
                    Image(systemName: article.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(article.isLiked ? Color.red : Color.primary)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(article.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .overlay(
                                    Capsule()
                                        .stroke(Color(.systemGray3), lineWidth: 1)
                                )
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
