import SwiftUI

private let tagSections: [(title: String, tags: [String])] = [
    ("Technology",         ["AI", "Tech", "Security", "Quantum"]),
    ("Development",        ["Dev", "Swift", "iOS"]),
    ("Science & Space",    ["Science", "Space", "Health"]),
    ("Business & Finance", ["Finance", "Economy", "Business", "Crypto"]),
    ("Politics & World",   ["Politics", "Policy", "Defense", "Law"]),
    ("Society",            ["Society", "Sports", "Food"]),
    ("Climate & Energy",   ["Climate", "Energy", "Transport"]),
]

struct OnboardingView: View {
    let onComplete: ([String]) -> Void

    @State private var showInterests = false
    @State private var selectedTags: Set<String> = []

    var body: some View {
        ZStack {
            if showInterests {
                interestsScreen
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                welcomeScreen
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal:   .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.85), value: showInterests)
    }

    // MARK: – Welcome

    private var welcomeScreen: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.accentColor.ignoresSafeArea(edges: .top)
                VStack(spacing: 10) {
                    Text("A")
                        .font(.system(size: 80, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("AXIOM")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                        .tracking(10)
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.42)

            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Your news,\nyour way.")
                        .font(.largeTitle.bold())
                    Text("Personalised stories from the publishers and topics that matter to you.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button {
                    withAnimation {
                        showInterests = true
                    }
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 28)
        }
    }

    // MARK: – Interests

    private var interestsScreen: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 6) {
                Button {
                    withAnimation { showInterests = false }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 8)

                Text("What interests you?")
                    .font(.largeTitle.bold())
                Text("Pick topics to personalise your feed from day one.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 20)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    ForEach(tagSections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(section.title.uppercased())
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .tracking(1)

                            FlowLayout(spacing: 8) {
                                ForEach(section.tags, id: \.self) { tag in
                                    TagToggleChip(
                                        tag: tag,
                                        isSelected: selectedTags.contains(tag)
                                    ) {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                            if selectedTags.contains(tag) {
                                                selectedTags.remove(tag)
                                            } else {
                                                selectedTags.insert(tag)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 140)
            }

            continueBar
        }
    }

    private var continueBar: some View {
        VStack(spacing: 10) {
            Button {
                onComplete(Array(selectedTags))
            } label: {
                HStack(spacing: 8) {
                    Text(selectedTags.isEmpty ? "Skip for now" : "Continue")
                        .font(.headline)
                    if !selectedTags.isEmpty {
                        Text("\(selectedTags.count) selected")
                            .font(.subheadline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.white.opacity(0.25))
                            .clipShape(Capsule())
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(selectedTags.isEmpty ? Color.secondary : Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .animation(.spring(response: 0.3), value: selectedTags.isEmpty)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
        .padding(.top, 12)
        .background(
            LinearGradient(
                colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

// MARK: – Supporting views

private struct TagToggleChip: View {
    let tag: String
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 5) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .transition(.scale.combined(with: .opacity))
                }
                Text(tag)
                    .font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(subviews: subviews, width: proposal.width ?? 0).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let offsets = layout(subviews: subviews, width: bounds.width).offsets
        for (subview, point) in zip(subviews, offsets) {
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func layout(subviews: Subviews, width: CGFloat) -> (offsets: [CGPoint], size: CGSize) {
        var offsets: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowH: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && !offsets.isEmpty {
                x = 0; y += rowH + spacing; rowH = 0
            }
            offsets.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowH = max(rowH, size.height)
        }
        return (offsets, CGSize(width: width, height: y + rowH))
    }
}
