import Foundation
import NaturalLanguage

/// Ranks articles using a multi-signal scoring model.
///
/// Score components (in priority order):
///  1. Tag interest weights        — sum of tagWeights for each article tag
///  2. Publisher interest weight   — publisherWeights[publisher]
///  3. Semantic NL similarity      — cosine similarity between article headline
///                                   and the user's recent-read context (NLEmbedding)
///  4. Recency bonus               — linear decay, full at 0h, zero at 24h
///  5. Already-read penalty        — score × 0.2 if article is in read history
///
/// An actor so the NLEmbedding lookups (loading the model, computing per-headline
/// vectors) always run off the main actor and the vector cache stays race-free
/// without manual locking.
actor RecommendationEngine {

    static let shared = RecommendationEngine()

    // Cached word embedding loaded once per app session
    private let embedding: NLEmbedding? = NLEmbedding.wordEmbedding(for: .english)

    // Document vector cache keyed by article UUID to avoid re-computing
    private var vectorCache: [UUID: [Double]] = [:]

    private init() {}

    // MARK: – Public

    func rank(
        articles: [Article],
        tagWeights: [String: Double],
        publisherWeights: [String: Double],
        readHistory: [Article]
    ) -> [Article] {
        let readIds = Set(readHistory.map(\.id))

        // Build semantic context from the 10 most recently read headlines
        let contextVector: [Double] = {
            let text = readHistory.prefix(10).map(\.headline).joined(separator: " ")
            return documentVector(for: text)
        }()

        return articles
            .map { article -> (Article, Double) in
                (article, score(article, tagWeights: tagWeights, publisherWeights: publisherWeights, readIds: readIds, contextVector: contextVector))
            }
            .sorted { $0.1 > $1.1 }
            .map(\.0)
    }

    // MARK: – Scoring

    private func score(
        _ article: Article,
        tagWeights: [String: Double],
        publisherWeights: [String: Double],
        readIds: Set<UUID>,
        contextVector: [Double]
    ) -> Double {
        var s = 0.0

        // 1. Tag interest
        for tag in article.tags {
            s += (tagWeights[tag] ?? 0) * 1.0
        }

        // 2. Publisher interest
        s += (publisherWeights[article.publisher] ?? 0) * 0.8

        // 3. Semantic similarity to recent reads
        if !contextVector.isEmpty {
            let articleVec = documentVector(for: article.headline, cacheKey: article.id)
            s += cosineSimilarity(articleVec, contextVector) * 1.5
        }

        // 4. Recency bonus
        s += recencyBonus(article.publishedAt) * 0.5

        // 5. Already-read penalty — keep in feed but push to bottom
        if readIds.contains(article.id) { s *= 0.2 }

        return s
    }

    // MARK: – Recency

    private func recencyBonus(_ publishedAt: String) -> Double {
        if let r = publishedAt.range(of: #"\d+(?=h)"#, options: .regularExpression),
           let h = Double(publishedAt[r]) {
            return max(0, 1.0 - h / 24.0)  // full bonus <1h, zero at 24h
        }
        if let r = publishedAt.range(of: #"\d+(?=d)"#, options: .regularExpression),
           let d = Double(publishedAt[r]) {
            return max(0, 1.0 - d / 7.0)   // decays to zero over 7 days
        }
        return 0
    }

    // MARK: – NLEmbedding helpers

    /// Returns average word vector for a text string, with optional UUID cache key.
    private func documentVector(for text: String, cacheKey: UUID? = nil) -> [Double] {
        if let key = cacheKey, let cached = vectorCache[key] { return cached }

        guard let emb = embedding else { return [] }

        let tokenizer = NLTokenizer(unit: .word)
        let lower = text.lowercased()
        tokenizer.string = lower

        var vectors: [[Double]] = []
        tokenizer.enumerateTokens(in: lower.startIndex..<lower.endIndex) { range, _ in
            if let vec = emb.vector(for: String(lower[range])) {
                vectors.append(vec)
            }
            return true
        }

        guard !vectors.isEmpty else { return [] }
        let dim = vectors[0].count
        var avg = [Double](repeating: 0, count: dim)
        for vec in vectors {
            for i in 0..<dim { avg[i] += vec[i] }
        }
        let result = avg.map { $0 / Double(vectors.count) }

        if let key = cacheKey { vectorCache[key] = result }
        return result
    }

    /// Cosine similarity in [-1, 1]. Returns 0 if either vector is empty or zero-magnitude.
    private func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }
        let dot  = zip(a, b).reduce(0.0) { $0 + $1.0 * $1.1 }
        let magA = sqrt(a.reduce(0.0) { $0 + $1 * $1 })
        let magB = sqrt(b.reduce(0.0) { $0 + $1 * $1 })
        guard magA > 0, magB > 0 else { return 0 }
        return dot / (magA * magB)
    }
}
