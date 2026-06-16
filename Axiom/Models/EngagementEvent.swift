import Foundation

enum EngagementEvent {
    // Onboarding seed
    case onboardingSelected(tags: [String])

    // Article opened (tap from feed)
    case articleOpened(article: Article)

    // Article dismissed — scroll depth [0-1] and time on screen in seconds
    case articleRead(article: Article, readFraction: Double, timeSpent: TimeInterval)

    // Explicit follow / unfollow
    case topicFollowed(tag: String)
    case topicUnfollowed(tag: String)
    case publisherFollowed(name: String)
    case publisherUnfollowed(name: String)

    // Implicit filter signals
    case tagFiltered(tag: String)
    case publisherFiltered(name: String)
}
