import Foundation
import Combine

/// Stores per-tag and per-publisher interest weights derived from the user's engagement.
/// Owned by ContentView as @StateObject and injected into the SwiftUI environment.
final class UserInterestProfile: ObservableObject {
    @Published private(set) var tagWeights:       [String: Double] = [:]
    @Published private(set) var publisherWeights: [String: Double] = [:]

    private let defaults = UserDefaults.standard
    private enum Keys {
        static let tags       = "axiom_tagWeights"
        static let publishers = "axiom_publisherWeights"
    }

    init() { load() }

    // MARK: – Public API

    func record(_ event: EngagementEvent) {
        switch event {

        case .onboardingSelected(let tags):
            // Strong seed: user deliberately chose these interests
            tags.forEach { adjustTag($0, by: 1.5) }

        case .articleOpened(let article):
            // Opening signals mild interest
            article.tags.forEach { adjustTag($0, by: 0.3) }
            adjustPublisher(article.publisher, by: 0.2)

        case .articleRead(let article, let fraction, let timeSpent):
            let delta = engagementDelta(fraction: fraction, seconds: timeSpent)
            article.tags.forEach { adjustTag($0, by: delta.tag) }
            adjustPublisher(article.publisher, by: delta.publisher)

        case .topicFollowed(let tag):
            adjustTag(tag, by: 2.0)

        case .topicUnfollowed(let tag):
            adjustTag(tag, by: -1.5)

        case .publisherFollowed(let name):
            adjustPublisher(name, by: 2.0)

        case .publisherUnfollowed(let name):
            adjustPublisher(name, by: -1.5)

        case .tagFiltered(let tag):
            // Actively filtering by a tag is implicit interest
            adjustTag(tag, by: 0.5)

        case .publisherFiltered(let name):
            adjustPublisher(name, by: 0.3)
        }

        persist()
    }

    // MARK: – Engagement delta calculation

    /// Converts raw scroll depth + time into tag and publisher weight deltas.
    ///
    /// Tiers:
    /// - Quick bounce  (<15s AND <25% read) → slight negative (user was not interested)
    /// - Glance        (≥15s  OR  ≥25%)     → small positive
    /// - Light read    (≥25% AND ≥30s)      → moderate positive
    /// - Deep read     (≥75% AND ≥60s)      → strong positive
    /// - Full read     (≥90% AND ≥90s)      → very strong positive
    private func engagementDelta(fraction: Double, seconds: TimeInterval) -> (tag: Double, publisher: Double) {
        if seconds < 15 && fraction < 0.25 {
            return (-0.1, -0.05) // quick bounce — mild negative
        }
        switch (fraction, seconds) {
        case (0.9..., 90...): return (1.5, 0.9)   // full read
        case (0.75..., 60...): return (1.0, 0.6)  // deep read
        case (0.25..., 30...): return (0.5, 0.3)  // light read
        default:               return (0.2, 0.1)  // glance
        }
    }

    // MARK: – Helpers

    private func adjustTag(_ tag: String, by delta: Double) {
        tagWeights[tag] = max(0, (tagWeights[tag] ?? 0) + delta)
    }

    private func adjustPublisher(_ name: String, by delta: Double) {
        publisherWeights[name] = max(0, (publisherWeights[name] ?? 0) + delta)
    }

    // MARK: – Persistence

    private func persist() {
        defaults.set(tagWeights,       forKey: Keys.tags)
        defaults.set(publisherWeights, forKey: Keys.publishers)
    }

    private func load() {
        tagWeights       = defaults.dictionary(forKey: Keys.tags)       as? [String: Double] ?? [:]
        publisherWeights = defaults.dictionary(forKey: Keys.publishers) as? [String: Double] ?? [:]
    }
}
