# Axiom

A SwiftUI news reader with an on-device personalization engine. The app learns from reading behaviour — scroll depth, time on screen, topics tapped, publishers followed — and ranks a curated article feed accordingly. All processing happens on the device. No data leaves the app.

Built as Case 6: Intelligent Daily Reading Recommendations for Fontys University of Applied Sciences.

## Features

- Personalized home feed ranked by an on-device recommendation engine
- Engagement tracking: scroll depth and time on screen measured per article
- Interest weights that update silently on every interaction and persist across launches
- Follow/unfollow topics and publishers with immediate feed impact
- Tag-tap filtering with inline follow prompt
- Explore tab with 11 regional filters
- Favorites tab filtered by followed topics and publishers
- Full article reader sheet with share button and read-progress bar
- Onboarding topic selection that seeds the initial interest profile
- Preferences screen showing live algorithm weights with reset option
- Pull-to-refresh with feed order frozen between refreshes

## How it works

`UserInterestProfile` stores per-tag and per-publisher weights derived from every user interaction. `RecommendationEngine` scores each article across five components — tag interest, publisher interest, semantic similarity via Apple's NLEmbedding, recency decay, and an already-read penalty — then sorts descending. The ranked list is frozen in `HomeView` until the next pull-to-refresh.

## Tech Stack

| Layer | Tools |
|---|---|
| UI | SwiftUI (iOS 17+) |
| Language | Swift 6 |
| Semantic similarity | Apple NaturalLanguage (NLEmbedding) |
| Persistence | UserDefaults + JSONEncoder |
| Backend | None — fully on-device |

## Requirements

- Xcode 15 or later
- iOS 17 or later (simulator or device)

## Setup

```bash
git clone https://github.com/Dimitar-Dim/Axiom.git
cd Axiom
open Axiom.xcodeproj
```

Select a simulator or device and press `⌘R`. No API keys, package installs, or environment variables required.

To reset the interest profile: Profile → Preferences → Reset Weights.  
To re-trigger onboarding: delete and reinstall the app.

## Project Structure

```
Axiom/
├── AxiomApp.swift                  # Entry point, pre-warms NLEmbedding off main thread
├── ContentView.swift               # Root view — owns all shared state, drives persistence
├── Models/
│   ├── Article.swift               # Article model + curated sample dataset
│   ├── UserInterestProfile.swift   # Tag/publisher weight store, engagement event handler
│   ├── RecommendationEngine.swift  # Multi-signal scoring and ranking (actor)
│   ├── EngagementEvent.swift       # Enum of all trackable user interactions
│   ├── PublisherTheme.swift        # Publisher accent colours and initials
│   ├── ProfileModels.swift         # FollowedTopic and FollowedPublisher models
│   ├── NewsService.swift           # NewsAPI integration (stub — not active)
│   └── StoryProcessor.swift        # Article deduplication and tag inference
├── Components/
│   ├── ArticleCard.swift           # Feed card with tag chips and publisher avatar
│   ├── BottomTabBar.swift          # Custom floating tab bar
│   └── TopHeaderView.swift         # Floating header with profile trigger
└── Views/
    ├── HomeView.swift              # Personalized ranked feed with pull-to-refresh
    ├── ExploreView.swift           # Regional article browser
    ├── FavoritesView.swift         # Feed filtered by followed topics and publishers
    ├── ArticleDetailView.swift     # Full reader sheet with scroll tracking
    ├── ProfileView.swift           # Followed topics, publishers, read history
    ├── PreferencesView.swift       # Live weight viewer and reset
    └── OnboardingView.swift        # First-launch topic selection
```

## License

MIT
