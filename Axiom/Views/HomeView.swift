import SwiftUI

struct HomeView: View {
    @State private var articles = Article.samples

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach($articles) { $article in
                    ArticleCard(article: $article)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 110)
        }
        // Reserve space for the floating TopHeaderView (56 top pad + 44 bar + 14 bottom = 114).
        .safeAreaInset(edge: .top) { Color.clear.frame(height: 114) }
    }
}
