//
//  ContentView.swift
//  Axiom
//

import SwiftUI

// MARK: - Models

struct Article: Identifiable {
    let id = UUID()
    let headline: String
    let publisher: String
    let tags: [String]
    var isLiked: Bool = false
}

extension Article {
    static let samples: [Article] = [
        Article(
            headline: "The Future of Artificial Intelligence in Healthcare",
            publisher: "MIT Review",
            tags: ["AI", "Health", "Tech"]
        ),
        Article(
            headline: "Climate Change and Its Economic Impact on Global Markets",
            publisher: "The Economist",
            tags: ["Climate", "Economy", "Policy"]
        ),
        Article(
            headline: "SwiftUI 6: What's New for Apple Developers This Fall",
            publisher: "Swift Blog",
            tags: ["Swift", "iOS", "Dev"]
        ),
        Article(
            headline: "SpaceX Starship's Latest Mission Breaks Records",
            publisher: "Space.com",
            tags: ["Space", "Science"]
        ),
        Article(
            headline: "Inside the Rise of Decentralised Finance",
            publisher: "Bloomberg",
            tags: ["DeFi", "Crypto", "Finance"]
        ),
        Article(
            headline: "How Quantum Computing Will Transform Cybersecurity",
            publisher: "Wired",
            tags: ["Quantum", "Security", "Tech"]
        ),
    ]
}

// MARK: - Tab

enum AppTab {
    case explore, home, favorites
}

// MARK: - Root

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .explore:
                    PlaceholderView(title: "Explore")
                case .home:
                    HomeView()
                case .favorites:
                    PlaceholderView(title: "Favorites")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Home

struct HomeView: View {
    @State private var searchText = ""
    @State private var articles = Article.samples

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Button {
                } label: {
                    Image(systemName: "person.circle")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(.primary)
                }

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 15))
                    TextField("Search", text: $searchText)
                        .font(.system(size: 16))
                    Spacer(minLength: 0)
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.top, 56)
            .padding(.bottom, 14)
            .background(Color(.systemBackground))

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach($articles) { $article in
                        ArticleCard(article: $article)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 110)
            }
        }
    }
}

// MARK: - Article Card

struct ArticleCard: View {
    @Binding var article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Thumbnail + Headline row
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(width: 88, height: 88)

                    Text(article.publisher)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Text(article.headline)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineSpacing(2)
                    .lineLimit(4)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }

            // Like + Tags row
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

// MARK: - Bottom Tab Bar

struct BottomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            TabBarButton(icon: "safari", selectedIcon: "safari.fill", tab: .explore, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "house", selectedIcon: "house.fill", tab: .home, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "heart", selectedIcon: "heart.fill", tab: .favorites, selectedTab: $selectedTab)
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .shadow(color: .black.opacity(0.1), radius: 16, x: 0, y: -2)
    }
}

struct TabBarButton: View {
    let icon: String
    let selectedIcon: String
    let tab: AppTab
    @Binding var selectedTab: AppTab

    var isSelected: Bool { selectedTab == tab }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        } label: {
            Image(systemName: isSelected ? selectedIcon : icon)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .frame(width: 56, height: 40)
                .background(
                    isSelected
                        ? Color(.systemGray5)
                        : Color.clear,
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Placeholder Views

struct PlaceholderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: title == "Explore" ? "safari" : "heart")
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
