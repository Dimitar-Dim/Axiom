import Foundation
import NaturalLanguage
#if canImport(FoundationModels)
import FoundationModels
#endif

// MARK: - Batch tag output (all headlines in one LLM call)

#if canImport(FoundationModels)
@available(iOS 18.1, *)
@Generable
private struct BatchTagResult {
    @Guide(description: "For each input headline (in order), one comma-separated list of applicable tags from: AI, Climate, Crypto, Space, Tech, Economy, Politics, Defense, Geopolitics, Finance, Health, Science, Energy, Security, Society, Transport, News. One entry per headline, same order as input.")
    var tagLines: [String]
}
#endif

// MARK: - Story Processor

enum StoryProcessor {

    private static let knownTags: Set<String> = [
        "AI", "Climate", "Crypto", "Space", "Tech", "Economy",
        "Politics", "Defense", "Geopolitics", "Finance", "Health",
        "Science", "Energy", "Security", "Society", "Transport",
        "News", "Dev", "iOS", "Swift",
    ]

    // Cosine-distance threshold below which two headlines are the same story.
    // NLEmbedding cosine distance ∈ [0, 2]; 0.28 ≈ 0.72+ cosine similarity.
    private static let storyThreshold: Double = 0.28

    // MARK: - Fast path (called during refresh, blocks until done)

    /// Merge new articles, deduplicate same-story clusters, keep most neutral per cluster.
    /// No AI tagging here — call aiRetag() as a background Task after this returns.
    @MainActor
    static func process(incoming: [Article], pool: [Article]) async -> [Article] {
        let known = Set(pool.map(\.headline))
        let fresh = incoming.filter { !known.contains($0.headline) }
        guard !fresh.isEmpty else { return pool }
        return await deduplicateByStory(pool + fresh)
    }

    // MARK: - Background AI retag (fire-and-forget from call site)

    /// Re-tags only articles whose headlines are in `freshHeadlines` using one batch
    /// Apple Intelligence call. Returns the updated pool. Run inside a Task {}.
    @MainActor
    static func aiRetag(freshHeadlines: Set<String>, in pool: [Article]) async -> [Article] {
        #if canImport(FoundationModels) && !targetEnvironment(simulator)
        if #available(iOS 18.1, *) {
            let toTag = pool.filter { freshHeadlines.contains($0.headline) }
            guard !toTag.isEmpty else { return pool }
            if let tagged = try? await batchTag(toTag) {
                let tagMap = Dictionary(uniqueKeysWithValues: tagged.map { ($0.headline, $0.tags) })
                return pool.map { article in
                    guard let newTags = tagMap[article.headline] else { return article }
                    return article.retagged(newTags)
                }
            }
        }
        #endif
        return pool
    }

    // MARK: - One LLM call for all headlines

    #if canImport(FoundationModels)
    @available(iOS 18.1, *)
    private static func batchTag(_ articles: [Article]) async throws -> [Article] {
        guard case .available = SystemLanguageModel.default.availability else {
            throw CocoaError(.featureUnsupported)
        }

        let numbered = articles.enumerated()
            .map { "\($0.offset + 1). \($0.element.headline)" }
            .joined(separator: "\n")

        // Session creation + on-device inference run fully off the main actor.
        // First use loads the model synchronously and can take several seconds —
        // that must never happen on the actor driving the UI.
        let tagLines = try await Task.detached(priority: .userInitiated) {
            let session = LanguageModelSession(
                instructions: "You are a news classifier. Assign topic tags to headlines."
            )
            let prompt = "Classify each headline into topic tags. One tag-list per headline, same order.\n\n\(numbered)"
            let response = try await session.respond(to: prompt, generating: BatchTagResult.self)
            return response.content.tagLines
        }.value

        return zip(articles, tagLines).map { article, line in
            let tags = line.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { knownTags.contains($0) }
            return article.retagged(tags.isEmpty ? article.tags : tags)
        }
    }
    #endif

    // MARK: - Story deduplication

    private static func deduplicateByStory(_ articles: [Article]) async -> [Article] {
        await Task.detached(priority: .userInitiated) {
            guard let embedding = NLEmbedding.sentenceEmbedding(for: .english) else {
                return articles
            }
            return cluster(articles, embedding: embedding).map { pickMostNeutral(from: $0) }
        }.value
    }

    // Greedy single-pass: each article joins the first cluster within threshold distance.
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

    // Pick article with sentiment score closest to 0 = most objective/neutral.
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
            id: id, headline: headline, publisher: publisher, tags: newTags,
            publishedAt: publishedAt, body: body, imageURL: imageURL,
            location: location, url: url
        )
    }
}
