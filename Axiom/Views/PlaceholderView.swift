import SwiftUI

struct PlaceholderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: title == "Explore" ? "globe.americas" : "heart")
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
