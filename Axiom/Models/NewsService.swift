import Foundation

// MARK: - Raw API types

private struct RawResponse: Decodable {
    let articles: [RawArticle]?
}

private struct RawArticle: Decodable {
    let title: String?
    let description: String?
    let content: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: RawSource
}

private struct RawSource: Decodable {
    let name: String?
}

// MARK: - Service

enum NewsService {

    // In-memory cache keyed by request signature — survives the session, not the app restart
    @MainActor private static var cache: [String: [Article]] = [:]

    // MARK: Public

    @MainActor
    static func topHeadlines(pageSize: Int = 10) async throws -> [Article] {
        try await get(endpoint: "top-headlines",
                      params: ["country": "us", "pageSize": "\(pageSize)"])
    }

    @MainActor
    static func forCountry(_ code: String, locationName: String, pageSize: Int = 10) async throws -> [Article] {
        try await get(endpoint: "top-headlines",
                      params: ["country": code, "pageSize": "\(pageSize)"],
                      location: locationName)
    }

    @MainActor
    static func forQuery(_ query: String, pageSize: Int = 10) async throws -> [Article] {
        let q = query.trimmingCharacters(in: .whitespaces)
        guard q.count >= 2 else { return [] }
        return try await get(endpoint: "everything",
                             params: ["q": q,
                                      "language": "en",
                                      "sortBy": "publishedAt",
                                      "pageSize": "\(pageSize)"])
    }

    // MARK: Private

    @MainActor
    private static func get(endpoint: String,
                             params: [String: String],
                             location: String? = nil) async throws -> [Article] {
        let key = endpoint + "|" + params.sorted { $0.key < $1.key }
                                        .map { "\($0.key)=\($0.value)" }
                                        .joined(separator: "&")
        if let hit = cache[key] { return hit }

        var comps = URLComponents(string: "https://newsapi.org/v2/\(endpoint)")!
        comps.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            + [URLQueryItem(name: "apiKey", value: Secrets.newsAPIKey)]

        guard let url = comps.url else { throw URLError(.badURL) }

        // Network request + JSON decoding run off the main actor so the UI never blocks
        let result = try await Task.detached(priority: .userInitiated) {
            let (data, _) = try await URLSession.shared.data(from: url)
            let raw = try JSONDecoder().decode(RawResponse.self, from: data)
            return (raw.articles ?? []).compactMap { Article(rawItem: $0, location: location) }
        }.value

        cache[key] = result
        return result
    }
}

// MARK: - Article mapping

private extension Article {
    init?(rawItem a: RawArticle, location: String? = nil) {
        guard
            let title = a.title, !title.isEmpty, title != "[Removed]",
            let sourceName = a.source.name, !sourceName.isEmpty
        else { return nil }

        // Strip " - Source Name" suffix NewsAPI appends to most titles
        let headline: String = {
            guard let lastRange = title.range(of: " - ", options: .backwards) else { return title }
            let suffix = title[lastRange.upperBound...]
            return suffix.count < 60 ? String(title[..<lastRange.lowerBound]) : title
        }()

        // Combine description + stripped content for a richer body paragraph
        let body: String = {
            var parts: [String] = []
            if let desc = a.description, !desc.isEmpty {
                parts.append(desc.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            if let content = a.content {
                let stripped: String
                if let cut = content.range(of: " [+") {
                    stripped = String(content[..<cut.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    stripped = content.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if !stripped.isEmpty && stripped != parts.first {
                    parts.append(stripped)
                }
            }
            return parts.joined(separator: "\n\n")
        }()

        self.init(
            headline: headline,
            publisher: sourceName,
            tags: inferTags(from: headline),
            publishedAt: relativeTime(from: a.publishedAt),
            body: body,
            imageURL: a.urlToImage ?? "",
            location: location,
            url: a.url
        )
    }
}

// MARK: - Tag inference

private func inferTags(from headline: String) -> [String] {
    struct Rule { let pattern: String; let tags: [String] }
    let rules: [Rule] = [
        Rule(pattern: #"\bAI\b|artificial intelligence|machine learning|ChatGPT|OpenAI|Anthropic|\bLLM\b"#, tags: ["AI", "Tech"]),
        Rule(pattern: #"climate|carbon emission|global warming|renewable energy|solar power|wind energy"#,   tags: ["Climate"]),
        Rule(pattern: #"bitcoin|cryptocurrency|blockchain|DeFi|ethereum|\bNFT\b"#,                          tags: ["Crypto", "Finance"]),
        Rule(pattern: #"\bspace\b|NASA|rocket|astronaut|\bMars\b|lunar|satellite"#,                         tags: ["Space", "Science"]),
        Rule(pattern: #"\bApple\b|\bGoogle\b|\bMicrosoft\b|\bMeta\b|\bNvidia\b|Big Tech"#,                 tags: ["Tech"]),
        Rule(pattern: #"\beconomy\b|\bGDP\b|inflation|recession|trade war|tariff"#,                         tags: ["Economy"]),
        Rule(pattern: #"election|parliament|senate|congress|democrat|republican|labour|conservative"#,       tags: ["Politics", "Policy"]),
        Rule(pattern: #"\bwar\b|military|troops|missile|airstrike|ceasefire|\bconflict\b"#,                 tags: ["Defense"]),
        Rule(pattern: #"Ukraine|Russia|\bNATO\b|Putin|Zelensky|geopolit"#,                                  tags: ["Geopolitics"]),
        Rule(pattern: #"stock market|Wall Street|NASDAQ|S&P 500|\bIPO\b|\bearnings\b"#,                     tags: ["Finance"]),
        Rule(pattern: #"hospital|vaccine|\bdisease\b|\bcancer\b|\bFDA\b|\bNHS\b|medicine"#,                 tags: ["Health"]),
        Rule(pattern: #"quantum|nuclear fusion|\bbreakthrough\b|scientific discovery"#,                     tags: ["Science"]),
        Rule(pattern: #"\boil\b|\bgas\b|battery|\bEV\b|electric vehicle|hydrogen fuel"#,                   tags: ["Energy"]),
        Rule(pattern: #"\bSwift\b|\biOS\b|Xcode|\bWWDC\b|Apple developer"#,                                tags: ["Swift", "iOS", "Dev"]),
        Rule(pattern: #"cybersecurity|data breach|ransomware|malware|hacker"#,                              tags: ["Security", "Tech"]),
        Rule(pattern: #"housing crisis|rent prices|mortgage|real estate"#,                                  tags: ["Society"]),
        Rule(pattern: #"rail network|airline|electric car|EV charging|transport"#,                          tags: ["Transport"]),
        Rule(pattern: #"Federal Reserve|\bFed\b|interest rate|central bank|rate cut|rate hike"#,            tags: ["Finance", "Economy"]),
    ]
    var tags = Set<String>()
    for rule in rules {
        if headline.range(of: rule.pattern, options: [.regularExpression, .caseInsensitive]) != nil {
            rule.tags.forEach { tags.insert($0) }
        }
    }
    return tags.isEmpty ? ["News"] : Array(tags)
}

// MARK: - Date formatting

private func relativeTime(from iso: String?) -> String {
    guard let iso else { return "Recently" }
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    var date = f.date(from: iso)
    if date == nil {
        f.formatOptions = [.withInternetDateTime]
        date = f.date(from: iso)
    }
    guard let date else { return "Recently" }
    let hours = max(0, Int(-date.timeIntervalSinceNow / 3600))
    if hours < 1  { return "Just now" }
    if hours < 24 { return "\(hours)h ago" }
    return "\(hours / 24)d ago"
}
