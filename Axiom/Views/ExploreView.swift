import SwiftUI

enum Region: String, CaseIterable {
    case netherlands = "Netherlands"
    case uk          = "UK"
    case usa         = "USA"
    case germany     = "Germany"
    case france      = "France"
    case ukraine     = "Ukraine"
    case india       = "India"
    case china       = "China"
    case brazil      = "Brazil"
    case japan       = "Japan"
    case australia   = "Australia"
}

struct ExploreView: View {
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @Binding var searchText: String
    @Binding var readHistory: [Article]

    @State private var selectedRegion: Region = .netherlands
    @State private var showRegionPicker = false
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20

    private let allArticles = Article.samples

    private var regionArticles: [Article] {
        var result = allArticles.filter {
            $0.location?.contains(selectedRegion.rawValue) == true
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            result = result.filter {
                $0.headline.lowercased().contains(q) ||
                $0.publisher.lowercased().contains(q) ||
                $0.tags.contains(where: { $0.lowercased().contains(q) })
            }
        }
        return result.sorted { ageMinutes($0.publishedAt) < ageMinutes($1.publishedAt) }
    }

    private var displayedArticles: [Article] {
        Array(regionArticles.prefix(displayCount))
    }

    private var hasMore: Bool { displayCount < regionArticles.count }

    private func ageMinutes(_ s: String) -> Int {
        if let r = s.range(of: #"\d+(?=h)"#, options: .regularExpression), let n = Int(s[r]) { return n * 60 }
        if let r = s.range(of: #"\d+(?=d)"#, options: .regularExpression), let n = Int(s[r]) { return n * 1440 }
        return Int.max
    }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }

    private func recordRead(_ article: Article) {
        readHistory.removeAll { $0.id == article.id }
        readHistory.insert(article, at: 0)
    }

    private func togglePublisher(_ publisher: String) {
        if let i = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: i)
        } else {
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: 0))
        }
    }

    var body: some View {
        Group {
            if regionArticles.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "globe")
                        .font(.system(size: 48, weight: .thin))
                        .foregroundStyle(.secondary)
                    Text("No articles for \(selectedRegion.rawValue)")
                        .font(.title3.bold())
                        .foregroundStyle(.secondary)
                    Button { showRegionPicker = true } label: {
                        Text("Change region")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.accentColor)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        locationHeader

                        ForEach(displayedArticles) { article in
                            ArticleCard(
                                article: article,
                                isPublisherFollowed: isPublisherFollowed(article.publisher),
                                onTogglePublisher: { togglePublisher(article.publisher) },
                                onSelectTag: { _ in },
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
            }
        }
        .sheet(isPresented: $showRegionPicker) { regionPickerSheet }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(
                article: article,
                isPublisherFollowed: isPublisherFollowed(article.publisher),
                onTogglePublisher: { togglePublisher(article.publisher) },
                onSelectTag: { _ in }
            )
            .presentationDragIndicator(.visible)
        }
        .onChange(of: selectedRegion) { displayCount = 20 }
        .onChange(of: searchText)     { displayCount = 20 }
    }

    private var locationHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("LOCAL NEWS")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1)
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.accentColor)
                    Text(selectedRegion.rawValue)
                        .font(.title3.bold())
                }
            }
            Spacer()
            Button { showRegionPicker = true } label: {
                HStack(spacing: 4) {
                    Text("Change")
                        .font(.subheadline.bold())
                    Image(systemName: "chevron.down")
                        .font(.caption2.bold())
                }
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 2)
        .padding(.bottom, 4)
    }

    private var regionPickerSheet: some View {
        NavigationStack {
            List(Region.allCases, id: \.self) { region in
                Button {
                    selectedRegion = region
                    showRegionPicker = false
                } label: {
                    HStack {
                        Text(region.rawValue)
                            .font(.body)
                            .foregroundStyle(.primary)
                        Spacer()
                        if region == selectedRegion {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                                .font(.subheadline.bold())
                        }
                    }
                }
            }
            .navigationTitle("Select Region")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showRegionPicker = false }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
