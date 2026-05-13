// SearchView.swift
// Seedly

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Plant] = []
    @State private var selectedFilter: SearchFilter = .all
    
    private let plantDatabase = PlantDatabase.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter chips
                filterBar
                
                if searchText.isEmpty {
                    suggestionsView
                } else if searchResults.isEmpty {
                    emptyResultsView
                } else {
                    resultsList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Search Plants")
            .searchable(text: $searchText, prompt: "Search by name, type, or conditions...")
            .onChange(of: searchText) { _, newValue in
                performSearch(query: newValue)
            }
            .onChange(of: selectedFilter) { _, _ in
                performSearch(query: searchText)
            }
        }
    }
    
    // MARK: - Filter Bar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter.rawValue)
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(selectedFilter == filter ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(selectedFilter == filter ? SeedlyTheme.primaryGreen : Color(.systemGray5))
                            )
                    }
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            .padding(.vertical, SeedlyTheme.paddingSmall)
        }
    }
    
    // MARK: - Suggestions
    private var suggestionsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SeedlyTheme.paddingLarge) {
                // Quick categories
                VStack(alignment: .leading, spacing: 12) {
                    Text("Browse by Category")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(PlantCategory.allCases) { category in
                            CategoryBrowseCard(category: category)
                        }
                    }
                }
                
                // Beginner picks
                VStack(alignment: .leading, spacing: 12) {
                    Text("Beginner Friendly")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    
                    ForEach(plantDatabase.beginnerFriendly().prefix(5)) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            SearchResultRow(plant: plant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Container friendly
                VStack(alignment: .leading, spacing: 12) {
                    Text("Container Friendly")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    
                    ForEach(plantDatabase.containerFriendly().prefix(5)) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            SearchResultRow(plant: plant)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            .padding(.top, SeedlyTheme.paddingMedium)
            .padding(.bottom, 100)
        }
    }
    
    // MARK: - Results List
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(searchResults) { plant in
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        SearchResultRow(plant: plant)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            .padding(.top, SeedlyTheme.paddingMedium)
        }
    }
    
    // MARK: - Empty Results
    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundStyle(.tertiary)
            
            Text("No plants found")
                .font(.system(.title3, design: .rounded, weight: .semibold))
            
            Text("Try a different search term or adjust your filters.")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Search Logic
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        var results = plantDatabase.search(query: query)
        
        switch selectedFilter {
        case .all: break
        case .vegetables: results = results.filter { $0.category == .vegetable }
        case .herbs: results = results.filter { $0.category == .herb }
        case .fruits: results = results.filter { $0.category == .fruit || $0.category == .berry }
        case .flowers: results = results.filter { $0.category == .flower }
        case .beginner: results = results.filter { $0.difficulty == .beginner }
        }
        
        searchResults = results
    }
}

// MARK: - Search Filter

enum SearchFilter: String, CaseIterable {
    case all = "All"
    case vegetables = "Vegetables"
    case herbs = "Herbs"
    case fruits = "Fruits"
    case flowers = "Flowers"
    case beginner = "Beginner"
}

// MARK: - Search Result Row

struct SearchResultRow: View {
    let plant: Plant
    
    var body: some View {
        HStack(spacing: 14) {
            // Plant icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(SeedlyTheme.accentGreen.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: plant.category.icon)
                    .font(.title3)
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(plant.localizedName())
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                
                HStack(spacing: 6) {
                    Text(plant.scientificName)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .italic()
                }
            }
            
            Spacer()
            
            // Difficulty indicator
            Text(plant.difficulty.rawValue.prefix(3).capitalized)
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundStyle(difficultyColor(plant.difficulty))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(difficultyColor(plant.difficulty).opacity(0.1))
                )
            
            Image(systemName: "chevron.right")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }
    
    private func difficultyColor(_ level: DifficultyLevel) -> Color {
        switch level {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        case .expert: return .purple
        }
    }
}

// MARK: - Category Browse Card

struct CategoryBrowseCard: View {
    let category: PlantCategory
    @EnvironmentObject var localization: LocalizationManager
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundStyle(SeedlyTheme.primaryGreen)
            
            Text(localization.categoryName(category))
                .font(.system(.caption, design: .rounded, weight: .medium))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    SearchView()
}
