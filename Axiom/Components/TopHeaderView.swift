import SwiftUI

struct TopHeaderView: View {
    @Binding var showProfile: Bool
    @Binding var searchText: String

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
                TextField("Search articles, publishers…", text: $searchText)
                    .font(.system(size: 16))
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                Spacer(minLength: 0)
                if searchText.isEmpty {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 15))
                } else {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color(.systemGray3))
                            .font(.system(size: 15))
                    }
                    .buttonStyle(.plain)
                }
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
