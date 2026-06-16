//
//  AxiomApp.swift
//  Axiom
//

import SwiftUI
import NaturalLanguage

@main
struct AxiomApp: App {
    init() {
        // Pre-load the sentence embedding model off the main thread so the first
        // story-deduplication pass doesn't pay the model-load cost during a fetch.
        // Apple Intelligence's on-device model is deliberately NOT pre-warmed here —
        // loading it is itself a heavy, system-wide operation that competes with
        // SwiftUI's first render and stalls launch. It loads lazily inside
        // StoryProcessor.batchTag's Task.detached, fully off the main actor, the
        // first time tagging actually runs.
        Task.detached(priority: .background) {
            _ = NLEmbedding.sentenceEmbedding(for: .english)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
