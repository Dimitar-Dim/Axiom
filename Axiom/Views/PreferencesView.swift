import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var profile: UserInterestProfile
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirm = false

    private var sortedTags: [(String, Double)] {
        profile.tagWeights.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }
    private var sortedPublishers: [(String, Double)] {
        profile.publisherWeights.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }
    private var maxWeight: Double {
        let all = Array(profile.tagWeights.values) + Array(profile.publisherWeights.values)
        return max(all.max() ?? 1.0, 0.01)
    }
    private var hasWeights: Bool { !sortedTags.isEmpty || !sortedPublishers.isEmpty }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    infoCard

                    if !sortedTags.isEmpty {
                        weightSection(title: "Topics", icon: "tag.fill", items: sortedTags)
                    }
                    if !sortedPublishers.isEmpty {
                        weightSection(title: "Publishers", icon: "building.2.fill", items: sortedPublishers)
                    }
                    if !hasWeights {
                        emptyState
                    }
                    if hasWeights {
                        resetButton
                    }
                }
                .padding(16)
                .padding(.bottom, 20)
            }
            .navigationTitle("Algorithm Weights")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }.fontWeight(.semibold)
                }
            }
            .confirmationDialog("Reset all weights?", isPresented: $showResetConfirm, titleVisibility: .visible) {
                Button("Reset", role: .destructive) { profile.reset() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This removes all learned preferences. Your follows and history are kept.")
            }
        }
    }

    // MARK: – Info card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "brain")
                    .font(.headline)
                    .foregroundStyle(Color.accentColor)
                Text("How your feed learns")
                    .font(.headline)
            }
            Text("Every article you open, read, filter by, or follow adjusts these weights. Higher weights push matching articles toward the top of your feed on the next refresh.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            HStack(spacing: 16) {
                legendDot(color: .accentColor,          label: "Strong interest")
                legendDot(color: Color(.systemOrange),  label: "Moderate")
                legendDot(color: Color(.systemGray3),   label: "Low")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
        }
    }

    // MARK: – Weight section

    @ViewBuilder
    private func weightSection(title: String, icon: String, items: [(String, Double)]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(title.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .tracking(1)
                Spacer()
                Text("\(items.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider().padding(.horizontal, 16)

            ForEach(Array(items.enumerated()), id: \.element.0) { idx, item in
                weightRow(rank: idx + 1, name: item.0, weight: item.1)
                if idx < items.count - 1 {
                    Divider().padding(.horizontal, 16)
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 3)
    }

    private func weightRow(rank: Int, name: String, weight: Double) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text("\(rank)")
                    .font(.caption.monospacedDigit().bold())
                    .foregroundStyle(.tertiary)
                    .frame(width: 20, alignment: .trailing)
                Text(name)
                    .font(.subheadline.weight(.medium))
                Spacer()
                Text(String(format: "%.2f", weight))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGray5))
                    Capsule()
                        .fill(barColor(for: weight))
                        .frame(width: max(6, geo.size.width * CGFloat(weight / maxWeight)))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: weight)
                }
            }
            .frame(height: 5)
            .padding(.leading, 26)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func barColor(for weight: Double) -> Color {
        let ratio = weight / maxWeight
        if ratio > 0.6 { return Color.accentColor }
        if ratio > 0.25 { return Color(.systemOrange) }
        return Color(.systemGray3)
    }

    // MARK: – Supporting views

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "brain")
                .font(.system(size: 48, weight: .thin))
                .foregroundStyle(.secondary)
            Text("No weights yet")
                .font(.title3.bold())
                .foregroundStyle(.secondary)
            Text("Read and interact with articles to start building your interest profile.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top, 40)
    }

    private var resetButton: some View {
        Button { showResetConfirm = true } label: {
            Text("Reset all weights")
                .font(.subheadline.bold())
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
