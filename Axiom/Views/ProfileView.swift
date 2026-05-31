import SwiftUI

struct ProfileView: View {
    @State private var topics = FollowedTopic.samples
    @State private var publishers = FollowedPublisher.samples
    @State private var topicsExpanded = true
    @State private var publishersExpanded = true

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Account")
                    .font(.largeTitle.bold())
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)
            .background(Color(.systemBackground))

            ScrollView {
                VStack(spacing: 14) {
                    followSection(
                        title: "Topics I Follow",
                        count: topics.count,
                        expanded: $topicsExpanded
                    ) {
                        ForEach(topics) { topic in
                            TopicRow(name: topic.name, count: topic.articleCount) {
                                withAnimation { topics.removeAll { $0.id == topic.id } }
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
                            TopicRow(name: publisher.name, count: publisher.articleCount) {
                                withAnimation { publishers.removeAll { $0.id == publisher.id } }
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
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
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
    let count: Int
    let onRemove: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(count) articles")
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
