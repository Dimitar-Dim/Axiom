import SwiftUI

struct TopHeaderView: View {
    @Binding var showProfile: Bool
    @State private var searchText = ""

    var body: some View {
        HStack(spacing: 10) {
            Button {
                showProfile = true
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(.primary)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 15))
                TextField("Search", text: $searchText)
                    .font(.system(size: 16))
                Spacer(minLength: 0)
                Image(systemName: "mic.fill")
                    .foregroundStyle(.secondary)
                    .font(.system(size: 15))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
        .padding(.bottom, 14)
        .background(Color(.systemBackground))
    }
}
