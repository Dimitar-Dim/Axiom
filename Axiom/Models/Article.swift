import Foundation

struct Article: Identifiable {
    let id = UUID()
    let headline: String
    let publisher: String
    let tags: [String]
    let publishedAt: String
    var isLiked: Bool = false
}

extension Article {
    static let samples: [Article] = [
        Article(
            headline: "The Future of Artificial Intelligence in Healthcare",
            publisher: "MIT Review",
            tags: ["AI", "Health", "Tech"],
            publishedAt: "2h ago"
        ),
        Article(
            headline: "Climate Change and Its Economic Impact on Global Markets",
            publisher: "The Economist",
            tags: ["Climate", "Economy", "Policy"],
            publishedAt: "4h ago"
        ),
        Article(
            headline: "SwiftUI 6: What's New for Apple Developers This Fall",
            publisher: "Swift Blog",
            tags: ["Swift", "iOS", "Dev"],
            publishedAt: "6h ago"
        ),
        Article(
            headline: "SpaceX Starship's Latest Mission Breaks Records",
            publisher: "Space.com",
            tags: ["Space", "Science"],
            publishedAt: "8h ago"
        ),
        Article(
            headline: "Inside the Rise of Decentralised Finance",
            publisher: "Bloomberg",
            tags: ["DeFi", "Crypto", "Finance"],
            publishedAt: "1d ago"
        ),
        Article(
            headline: "How Quantum Computing Will Transform Cybersecurity",
            publisher: "Wired",
            tags: ["Quantum", "Security", "Tech"],
            publishedAt: "1d ago"
        ),
    ]
}
