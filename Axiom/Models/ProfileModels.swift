import Foundation

struct FollowedTopic: Identifiable {
    let id = UUID()
    let name: String
    let tag: String
    let articleCount: Int
}

struct FollowedPublisher: Identifiable {
    let id = UUID()
    let name: String
    let articleCount: Int
}

extension FollowedTopic {
    static let samples: [FollowedTopic] = [
        FollowedTopic(name: "Artificial Intelligence", tag: "AI",      articleCount: 14),
        FollowedTopic(name: "Climate & Environment",   tag: "Climate", articleCount: 9),
        FollowedTopic(name: "iOS Development",         tag: "iOS",     articleCount: 22),
        FollowedTopic(name: "Space Exploration",       tag: "Space",   articleCount: 6),
        FollowedTopic(name: "Finance & Economy",       tag: "Finance", articleCount: 11),
        FollowedTopic(name: "Cybersecurity",           tag: "Security",articleCount: 5),
    ]
}

extension FollowedPublisher {
    static let samples: [FollowedPublisher] = [
        FollowedPublisher(name: "MIT Review", articleCount: 8),
        FollowedPublisher(name: "The Economist", articleCount: 13),
        FollowedPublisher(name: "Swift Blog", articleCount: 4),
        FollowedPublisher(name: "Bloomberg", articleCount: 17),
        FollowedPublisher(name: "Wired", articleCount: 10),
    ]
}
