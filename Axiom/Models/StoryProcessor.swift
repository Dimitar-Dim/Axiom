import Foundation
import NaturalLanguage
#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: - Structured output for Apple Intelligence tagging

#if canImport(FoundationModels)
@available(iOS 18.1, *)
@Generable
private struct TagResult {
    @Guide(description: "Relevant topic tags that clearly apply to this headline. Choose only from: AI, Climate, Crypto, Space, Tech, Economy, Politics, Defense, Geopolitics, Finance, Health, Science, Energy, Security, Society, Transport. Return [\"News\"] if none clearly apply.")
    var tags: [String]
}
#endif

// MARK: - Story Processor

/// Drives the "garbage journalism" pipeline:
///   1. Re-tag incoming articles with on-device Apple Intelligence (regex fallback).
///   2. Merge into the pool.
///   3. Cluster articles that cover the same story (NLEmbedding cosine similarity).
///   4. Within each cluster, keep only the most neutral article (NLTagger sentimentScore).
enum StoryProcessor {

    private static let knownTags: Set<String> = [
        "AI", "Climate", "Crypto", "Space", "Tech", "Economy",
        "Politics", "Defense", "Geopolitics", "Finance", "Health",
        "Science", "Energy", "Security", "Society", "Transport",
        "News", "Dev", "iOS", "Swift",
    ]

    // Cosine-distance threshold below which two headlines are considered the same story.
    // NLEmbedding cosine distance ∈ [0, 2]; 0.28 ≈ 0.72+ cosine similarity.
    private static let storyThreshold: Double = 0.28

    // MARK: - Entry point

    /// Returns an updated pool: new articles are AI-tagged, same-story duplicates are
    /// collapsed to the single most neutral/objective article from each cluster.
    @MainActor
    static func process(incoming: [Article], pool: [Article]) async -> [Article] {
        let known = Set(pool.map(\.headline))
        let fresh = incoming.filter { !known.contains($0.headline) }
        guard !fresh.isEmpty else { return pool }

        let tagged = await aiTag(fresh)
        return await deduplicateByStory(pool + tagged)
    }

    // MARK: - AI Tagging

    private static func aiTag(_ articles: [Article]) async -> [Article] {
        #if canImport(FoundationModels) && !targetEnvironment(simulator)
        if #available(iOS 18.1, *) {
            if let result = try? await tagWithAppleIntelligence(articles) {
                return result
            }
        }
        #endif
        return articles  // keep regex tags from NewsService as fallback
    }

    #if canImport(FoundationModels)
    @available(iOS 18.1, *)
    private static func tagWithAppleIntelligence(_ articles: [Article]) async throws -> [Article] {
        guard case .available = SystemLanguageModel.default.availability else {
            throw CocoaError(.featureUnsupported)
        }

        let session = LanguageModelSession(
            instructions: "You are a news article classifier. Assign concise topic tags to headlines."
        )

        var result: [Article] = []
        for article in articles {
            let prompt = "Classify this headline: \"\(article.headline)\""
            let response = try await session.respond(to: prompt, generating: TagResult.self)
            let cleaned = response.content.tags.filter { knownTags.contains($0) }
            result.append(article.retagged(cleaned.isEmpty ? article.tags : cleaned))
        }
        return result
    }
    #endif

    // MARK: - Story Deduplication

    private static func deduplicateByStory(_ articles: [Article]) async -> [Article] {
        await Task.detached(priority: .userInitiated) {
            guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
                return articles
            }
            return cluster(articles, embedding: embedding).map { pickMostNeutral(from: $0) }
        }.value
    }

    /// Greedy single-pass clustering: each article joins the first existing cluster
    /// whose representative headline is within `storyThreshold` cosine distance.
    private static func cluster(_ articles: [Article], embedding: NLEmbedding) -> [[Article]] {
        var clusters: [[Article]] = []
        for article in articles {
            var placed = false
            for i in 0 ..< clusters.count {
                let dist = embedding.distance(
                    between: article.headline,
                    and: clusters[i][0].headline,
                    distanceType: .cosine
                )
                if dist < storyThreshold {
                    clusters[i].append(article)
                    placed = true
                    break
                }
            }
            if !placed { clusters.append([article]) }
        }
        return clusters
    }

    /// From a cluster of same-story articles, pick the one whose body sentiment
    /// is closest to 0 (neither positive nor negative = most objective).
    private static func pickMostNeutral(from cluster: [Article]) -> Article {
        guard cluster.count > 1 else { return cluster[0] }
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        return cluster.min {
            abs(sentimentScore($0, tagger: tagger)) < abs(sentimentScore($1, tagger: tagger))
        } ?? cluster[0]
    }

    private static func sentimentScore(_ article: Article, tagger: NLTagger) -> Double {
        let text = article.body.isEmpty ? article.headline : article.body
        tagger.string = text
        let (tag, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Double(tag?.rawValue ?? "0") ?? 0.0
    }
}

// MARK: - Article helper

private extension Article {
    func retagged(_ newTags: [String]) -> Article {
        Article(
            headline: headline, publisher: publisher, tags: newTags,
            publishedAt: publishedAt, body: body, imageURL: imageURL,
            location: location, url: url
        )
    }
}
