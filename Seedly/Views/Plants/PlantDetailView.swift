// PlantDetailView.swift
// Seedly

import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    @State private var selectedTab: PlantDetailTab = .overview
    @State private var isAddedToGarden = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favorites: FavoritesStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                plantHeader
                quickInfoBar
                tabSelector
                tabContent
            }
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favorites.toggle(plant.id)
                    }
                }) {
                    Image(systemName: favorites.isFavorite(plant.id) ? "heart.fill" : "heart")
                        .foregroundStyle(favorites.isFavorite(plant.id) ? .red : SeedlyTheme.primaryGreen)
                        .symbolEffect(.bounce, value: favorites.isFavorite(plant.id))
                }
                .accessibilityLabel(favorites.isFavorite(plant.id) ? "Remove from favorites" : "Add to favorites")
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToGardenButton
        }
    }
    
    // MARK: - Header
    private var plantHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Image placeholder
            LinearGradient(
                colors: [SeedlyTheme.accentGreen.opacity(0.4), SeedlyTheme.primaryGreen.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 260)
            .overlay(
                Image(systemName: plant.category.icon)
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.3))
            )
            
            // Plant name overlay
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.localizedName())
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(plant.scientificName)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .italic()
            }
            .padding(SeedlyTheme.paddingLarge)
            
            // Difficulty badge
            VStack {
                HStack {
                    Spacer()
                    Text(plant.difficulty.rawValue.capitalized)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(difficultyColor(plant.difficulty))
                        )
                }
                .padding()
                Spacer()
            }
        }
    }
    
    // MARK: - Quick Info Bar
    private var quickInfoBar: some View {
        HStack(spacing: 0) {
            QuickInfoItem(icon: "sun.max.fill", title: "Full Sun", subtitle: plant.sunlight.hours)
            QuickInfoItem(icon: "ruler", title: "Spacing", subtitle: "\(Int(plant.spacing.betweenPlantsCm))–\(Int(plant.spacing.betweenRowsCm)) cm")
            QuickInfoItem(icon: "drop.fill", title: "Water", subtitle: plant.waterNeeds.rawValue.capitalized)
            QuickInfoItem(icon: "calendar", title: "Harvest", subtitle: "\(plant.daysToHarvest.lowerBound)–\(plant.daysToHarvest.upperBound)")
        }
        .padding(.vertical, SeedlyTheme.paddingMedium)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(PlantDetailTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(SeedlyTheme.smoothAnimation) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 6) {
                        Text(tab.rawValue)
                            .font(.system(.subheadline, design: .rounded, weight: selectedTab == tab ? .semibold : .regular))
                            .foregroundStyle(selectedTab == tab ? SeedlyTheme.primaryGreen : .secondary)
                        
                        Rectangle()
                            .fill(selectedTab == tab ? SeedlyTheme.primaryGreen : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, SeedlyTheme.paddingSmall)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Tab Content
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .overview:
            overviewContent
        case .timeline:
            timelineContent
        case .companions:
            companionsContent
        case .notes:
            notesContent
        }
    }
    
    // MARK: - Overview
    private var overviewContent: some View {
        VStack(spacing: SeedlyTheme.paddingMedium) {
            // Growing conditions
            DetailSection(title: "Growing Conditions") {
                VStack(spacing: 12) {
                    DetailRow(icon: "sun.max.fill", title: "Sunlight", value: plant.sunlight.rawValue.camelCaseToWords())
                    DetailRow(icon: "drop.fill", title: "Water Needs", value: plant.waterNeeds.rawValue.capitalized)
                    DetailRow(icon: "thermometer", title: "Optimal Temp", value: "\(Int(plant.optimalTempCelsius.lowerBound))–\(Int(plant.optimalTempCelsius.upperBound))°C")
                    DetailRow(icon: "humidity.fill", title: "Humidity", value: plant.humidityPreference.rawValue.capitalized)
                    DetailRow(icon: "arrow.down.to.line", title: "Planting Depth", value: "\(plant.plantingDepthCm) cm")
                }
            }
            
            // Soil preferences
            DetailSection(title: "Soil Preferences") {
                FlowLayout(spacing: 8) {
                    ForEach(plant.soilPreferences, id: \.self) { soil in
                        Text(soil.rawValue.camelCaseToWords())
                            .font(.system(.caption, design: .rounded))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(SeedlyTheme.lightGreen)
                            )
                    }
                }
            }
            
            // Frost & Heat
            DetailSection(title: "Climate Tolerance") {
                VStack(spacing: 12) {
                    DetailRow(icon: "snowflake", title: "Frost Sensitivity", value: plant.frostSensitivity.rawValue.camelCaseToWords())
                    DetailRow(icon: "thermometer.sun.fill", title: "Heat Tolerance", value: plant.heatTolerance.rawValue.capitalized)
                    DetailRow(icon: "thermometer.low", title: "Min Soil Temp", value: "\(Int(plant.minSoilTempCelsius))°C")
                }
            }
            
            // Characteristics
            DetailSection(title: "Characteristics") {
                VStack(spacing: 12) {
                    DetailRow(icon: "clock", title: "Germination", value: "\(plant.germinationDays.lowerBound)–\(plant.germinationDays.upperBound) days")
                    DetailRow(icon: "arrow.triangle.2.circlepath", title: "Perennial", value: plant.perennial ? "Yes" : "No")
                    DetailRow(icon: "square.grid.2x2", title: "Container Friendly", value: plant.containerFriendly ? "Yes" : "No")
                    DetailRow(icon: "house.fill", title: "Greenhouse", value: plant.greenhouseSuitable ? "Yes" : "No")
                    if plant.indoorSeedWeeks != nil {
                        DetailRow(icon: "sparkle", title: "Indoor Start", value: "\(plant.indoorSeedWeeks!) weeks before last frost")
                    }
                }
            }
        }
        .padding(.top, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Timeline
    private var timelineContent: some View {
        VStack(spacing: 0) {
            if plant.indoorSeedWeeks != nil {
                TimelineItem(
                    icon: "house.fill",
                    title: "Start Seeds Indoors",
                    subtitle: "Mar 15 – Apr 5",
                    color: .purple,
                    isFirst: true
                )
            }
            
            TimelineItem(
                icon: "leaf.fill",
                title: "Transplant Outdoors",
                subtitle: "May 20 – Jun 5",
                color: .green,
                isFirst: plant.indoorSeedWeeks == nil
            )
            
            TimelineItem(
                icon: "basket.fill",
                title: "Harvest",
                subtitle: "Jul 25 – Sep 15",
                color: .orange,
                isFirst: false
            )
            
            TimelineItem(
                icon: "snowflake",
                title: "Frost Sensitive",
                subtitle: "Protect below 0°C",
                color: SeedlyTheme.frost,
                isFirst: false,
                isLast: true
            )
        }
        .padding(SeedlyTheme.paddingLarge)
    }
    
    // MARK: - Companions
    private var companionsContent: some View {
        VStack(spacing: SeedlyTheme.paddingMedium) {
            DetailSection(title: "Good Companions") {
                VStack(spacing: 8) {
                    ForEach(plant.companionPlants, id: \.self) { companion in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text(companion.capitalized)
                                .font(.system(.subheadline, design: .rounded))
                            Spacer()
                        }
                    }
                }
            }
            
            if !plant.incompatiblePlants.isEmpty {
                DetailSection(title: "Avoid Planting Near") {
                    VStack(spacing: 8) {
                        ForEach(plant.incompatiblePlants, id: \.self) { incompatible in
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                Text(incompatible.capitalized)
                                    .font(.system(.subheadline, design: .rounded))
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Notes
    private var notesContent: some View {
        VStack(spacing: SeedlyTheme.paddingMedium) {
            DetailSection(title: "Your Notes") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("No notes yet. Add notes about your experience growing \(plant.localizedName()).")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Button(action: {}) {
                        Label("Add Note", systemImage: "plus")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                    }
                }
            }
        }
        .padding(.top, SeedlyTheme.paddingMedium)
    }
    
    // MARK: - Add to Garden Button
    private var addToGardenButton: some View {
        Button(action: {
            withAnimation(SeedlyTheme.springAnimation) {
                isAddedToGarden.toggle()
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }) {
            HStack {
                Image(systemName: isAddedToGarden ? "checkmark" : "plus")
                Text(isAddedToGarden ? "Added to My Garden" : "Add to My Garden")
                    .font(.system(.body, design: .rounded, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isAddedToGarden ? SeedlyTheme.accentGreen : SeedlyTheme.primaryGreen)
            )
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.bottom, SeedlyTheme.paddingSmall)
        .background(.ultraThinMaterial)
    }
    
    private func difficultyColor(_ difficulty: DifficultyLevel) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .expert: return .purple
        }
    }
}

// MARK: - Plant Detail Tab

enum PlantDetailTab: String, CaseIterable {
    case overview = "Overview"
    case timeline = "Timeline"
    case companions = "Companions"
    case notes = "Notes"
}

// MARK: - Supporting Views

struct QuickInfoItem: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(SeedlyTheme.primaryGreen)
            Text(title)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
            Text(subtitle)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DetailSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .semibold))
            
            content
        }
        .padding(SeedlyTheme.paddingMedium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .padding(.horizontal, SeedlyTheme.paddingLarge)
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(SeedlyTheme.primaryGreen)
                .frame(width: 24)
            
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
        }
    }
}

struct TimelineItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var isFirst: Bool = false
    var isLast: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline line and dot
            VStack(spacing: 0) {
                if !isFirst {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 20)
                }
                
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.caption)
                        .foregroundStyle(color)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(width: 2, height: 30)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                Text(subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, isFirst ? 6 : 26)
            
            Spacer()
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangement(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangement(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }
    
    private func arrangement(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        
        return (positions, CGSize(width: maxWidth, height: currentY + lineHeight))
    }
}

// MARK: - String Extension

extension String {
    func camelCaseToWords() -> String {
        let pattern = "([a-z])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(startIndex..., in: self)
        let result = regex.stringByReplacingMatches(in: self, range: range, withTemplate: "$1 $2")
        return result.prefix(1).uppercased() + result.dropFirst()
    }
}

#Preview {
    NavigationStack {
        PlantDetailView(plant: PlantDatabase.mockPlants[0])
    }
}
