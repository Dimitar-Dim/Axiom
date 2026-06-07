# Axiom

A clean iOS news reader UI built with SwiftUI. Will feature an AI-based algorithm that will allow each user to have a custom feed, tailored for them.

## Features

- Card-based article feed with headline, publisher, timestamp, and tag chips
- Like/save articles with animated heart button
- Bottom tab bar with Explore, Home, and Favorites sections
- Floating top header with profile sheet trigger
- Profile screen showing followed topics and publishers with article counts
- Preferences and History navigation rows

## Tech Stack

| Layer | Tools |
|---|---|
| UI | SwiftUI |
| Language | Swift 6 |
| Platform | iOS 17+ |

## Requirements

- Xcode 16 or later
- iOS 17 or later (simulator or device)

## Setup

1. Clone the repo and open in Xcode:

```bash
git clone <repo-url>
cd Axiom
open Axiom.xcodeproj
```

2. Select a simulator or device.
3. Build and run (`⌘R`).

No API keys, dependencies, or environment variables required.

## Project Structure

```
Axiom/
├── Axiom/
│   ├── AxiomApp.swift              # App entry point
│   ├── ContentView.swift           # Root tab container + profile sheet
│   ├── Item.swift                  # Placeholder SwiftData model
│   ├── Models/
│   │   ├── Article.swift           # Article model + sample data
│   │   └── ProfileModels.swift     # FollowedTopic, FollowedPublisher + samples
│   ├── Components/
│   │   ├── ArticleCard.swift       # Card UI with like button and tag chips
│   │   ├── BottomTabBar.swift      # Custom floating tab bar
│   │   └── TopHeaderView.swift     # Floating header with profile trigger
│   └── Views/
│       ├── HomeView.swift          # Scrollable article feed
│       ├── ProfileView.swift       # Followed topics, publishers, settings rows
│       └── PlaceholderView.swift   # Stub for Explore and Favorites tabs
└── AxiomTests/
```

## License

MIT
