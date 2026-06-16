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

extension Region {
    var newsAPICountryCode: String? {
        switch self {
        case .netherlands: return "nl"
        case .uk:          return "gb"
        case .usa:         return "us"
        case .germany:     return "de"
        case .france:      return "fr"
        case .ukraine:     return "ua"
        case .india:       return "in"
        case .china:       return "cn"
        case .brazil:      return "br"
        case .japan:       return "jp"
        case .australia:   return "au"
        }
    }
}

struct ExploreView: View {
    let articles: [Article]
    let onRegionChange: (Region) async -> Void
    @Binding var followedPublishers: [FollowedPublisher]
    @Binding var followedTopics: [FollowedTopic]
    @Binding var searchText: String
    @Binding var readHistory: [Article]

    @EnvironmentObject var profile: UserInterestProfile
    @State private var selectedRegion: Region = .netherlands
    @State private var showRegionPicker = false
    @State private var selectedArticle: Article? = nil
    @State private var displayCount = 20
    @State private var activeTagFilter: String? = nil
    @State private var activePublisherFilter: String? = nil

    private var regionArticles: [Article] {
        var result = articles.filter {
            $0.location?.contains(selectedRegion.rawValue) == true
        }
        if let tag = activeTagFilter {
            result = result.filter { $0.tags.contains(tag) }
        }
        if let publisher = activePublisherFilter {
            result = result.filter { $0.publisher == publisher }
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

    private var displayedArticles: [Article] { Array(regionArticles.prefix(displayCount)) }
    private var hasMore: Bool { displayCount < regionArticles.count }

    private func ageMinutes(_ s: String) -> Int {
        if let r = s.range(of: #"\d+(?=h)"#, options: .regularExpression), let n = Int(s[r]) { return n * 60 }
        if let r = s.range(of: #"\d+(?=d)"#, options: .regularExpression), let n = Int(s[r]) { return n * 1440 }
        return Int.max
    }

    private func isPublisherFollowed(_ publisher: String) -> Bool {
        followedPublishers.contains(where: { $0.name == publisher })
    }
    private func isTopicFollowed(_ tag: String) -> Bool {
        followedTopics.contains(where: { $0.tag == tag })
    }
    private func recordRead(_ article: Article) {
        readHistory.removeAll { $0.id == article.id }
        readHistory.insert(article, at: 0)
        profile.record(.articleOpened(article: article))
    }
    private func togglePublisher(_ publisher: String) {
        if let i = followedPublishers.firstIndex(where: { $0.name == publisher }) {
            followedPublishers.remove(at: i)
            profile.record(.publisherUnfollowed(name: publisher))
        } else {
            let count = articles.filter { $0.publisher == publisher }.count
            followedPublishers.append(FollowedPublisher(name: publisher, articleCount: count))
            profile.record(.publisherFollowed(name: publisher))
        }
    }
    private func followTopic(_ tag: String) {
        guard !isTopicFollowed(tag) else { return }
        let count = articles.filter { $0.tags.contains(tag) }.count
        followedTopics.append(FollowedTopic(name: tag, tag: tag, articleCount: count))
        profile.record(.topicFollowed(tag: tag))
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
                    if activeTagFilter != nil || activePublisherFilter != nil {
                        Button {
                            withAnimation { activeTagFilter = nil; activePublisherFilter = nil }
                        } label: {
                            Text("Clear filter")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button { showRegionPicker = true } label: {
                            Text("Change region")
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        locationHeader
                        if let tag = activeTagFilter       { tagBanner(for: tag) }
                        if let pub = activePublisherFilter { publisherBanner(for: pub) }

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
                                onSelectPublisher: { pub in
                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                        activePublisherFilter = activePublisherFilter == pub ? nil : pub
                                        displayCount = 20
                                    }
                                },
                                onTap: { recordRead(article); selectedArticle = article }
                            )
                            .onAppear {
                                if article.id == displayedArticles.last?.id && hasMore { displayCount += 10 }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 110)
                }
                .scrollDismissesKeyboard(.immediately)
                .safeAreaInset(edge: .top) { Color.clear.frame(height: 114) }
            }
        }
        .sheet(isPresented: $showRegionPicker) { regionPickerSheet }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(
                article: article,
                isPublisherFollowed: isPublisherFollowed(article.publisher),
                onTogglePublisher: { togglePublisher(article.publisher) },
                onSelectTag: { tag in
                    selectedArticle = nil
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activeTagFilter = tag; displayCount = 20
                    }
                },
                onSelectPublisher: { pub in
                    selectedArticle = nil
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        activePublisherFilter = activePublisherFilter == pub ? nil : pub
                        displayCount = 20
                    }
                },
                onEngagement: { fraction, seconds in
                    profile.record(.articleRead(article: article, readFraction: fraction, timeSpent: seconds))
                }
            )
            .presentationDragIndicator(.visible)
        }
        .onChange(of: selectedRegion)        { activeTagFilter = nil; activePublisherFilter = nil; displayCount = 20 }
        .task(id: selectedRegion)            { await onRegionChange(selectedRegion) }
        .onChange(of: searchText)            { displayCount = 20 }
        .onChange(of: activeTagFilter)       { if let tag = $1 { activePublisherFilter = nil; profile.record(.tagFiltered(tag: tag)) } }
        .onChange(of: activePublisherFilter) { if let pub = $1 { activeTagFilter = nil; profile.record(.publisherFiltered(name: pub)) } }
    }

    // MARK: – Banners

    @ViewBuilder
    private func tagBanner(for tag: String) -> some View {
        let followed = isTopicFollowed(tag)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tag)
                    .font(.caption.bold())
                    .foregroundStyle(Color.accentColor)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { activeTagFilter = nil }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(.systemGray3)).font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
            if followed {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").font(.subheadline).foregroundStyle(.green)
                    Text("You're following \(tag)").font(.subheadline).foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text("Interested in \(tag)?").font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Button { withAnimation { followTopic(tag) } } label: {
                        Text("Follow topic").font(.subheadline.bold()).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(Color.accentColor).clipShape(Capsule())
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

    @ViewBuilder
    private func publisherBanner(for publisher: String) -> some View {
        let theme = PublisherTheme.of(publisher)
        let followed = isPublisherFollowed(publisher)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    ZStack {
                        Circle().fill(theme.color).frame(width: 16, height: 16)
                        Text(String(theme.initials.prefix(1))).font(.system(size: 8, weight: .bold)).foregroundStyle(.white)
                    }
                    Text(publisher).font(.caption.bold()).foregroundStyle(theme.color)
                }
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(theme.color.opacity(0.1)).clipShape(Capsule())
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { activePublisherFilter = nil }
                } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(Color(.systemGray3)).font(.system(size: 18))
                }
                .buttonStyle(.plain)
            }
            if followed {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").font(.subheadline).foregroundStyle(.green)
                    Text("You're following \(publisher)").font(.subheadline).foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Text("Follow \(publisher)?").font(.subheadline).foregroundStyle(.secondary)
                    Spacer()
                    Button { withAnimation { togglePublisher(publisher) } } label: {
                        Text("Follow").font(.subheadline.bold()).foregroundStyle(.white)
                            .padding(.horizontal, 14).padding(.vertical, 6)
                            .background(Color.accentColor).clipShape(Capsule())
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

    // MARK: – Header & Picker

    private var locationHeader: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("LOCAL NEWS")
                    .font(.caption2.bold()).foregroundStyle(.secondary).tracking(1)
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.subheadline.bold()).foregroundStyle(Color.accentColor)
                    Text(selectedRegion.rawValue).font(.title3.bold())
                }
            }
            Spacer()
            Button { showRegionPicker = true } label: {
                HStack(spacing: 4) {
                    Text("Change").font(.subheadline.bold())
                    Image(systemName: "chevron.down").font(.caption2.bold())
                }
                .foregroundStyle(Color.accentColor)
                .padding(.horizontal, 14).padding(.vertical, 8)
                .background(Color.accentColor.opacity(0.1)).clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 2).padding(.bottom, 4)
    }

    private var regionPickerSheet: some View {
        NavigationStack {
            List(Region.allCases, id: \.self) { region in
                Button {
                    selectedRegion = region
                    showRegionPicker = false
                } label: {
                    HStack {
                        Text(region.rawValue).font(.body).foregroundStyle(.primary)
                        Spacer()
                        if region == selectedRegion {
                            Image(systemName: "checkmark").foregroundStyle(Color.accentColor).font(.subheadline.bold())
                        }
                    }
                }
            }
            .navigationTitle("Select Region")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showRegionPicker = false }.fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
