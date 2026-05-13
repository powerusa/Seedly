// PlantsView.swift
// Seedly

import SwiftUI

struct PlantsView: View {
    @StateObject private var viewModel = PlantsViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @State private var showAllPlants = true
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented control
                segmentedControl
                
                // Category filter
                categoryScroll
                
                // Plants grid
                ScrollView {
                    plantsGrid
                        .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localization.myGarden)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localization.edit) {}
                        .foregroundStyle(SeedlyTheme.primaryGreen)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: localization.searchPlants)
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.applyFilters()
            }
        }
    }
    
    // MARK: - Segmented Control
    private var segmentedControl: some View {
        HStack(spacing: 0) {
            SegmentButton(title: localization.allPlants, isSelected: showAllPlants) {
                withAnimation { showAllPlants = true }
                viewModel.showFavoritesOnly = false
                viewModel.applyFilters()
            }
            SegmentButton(title: localization.favorites, isSelected: !showAllPlants) {
                withAnimation { showAllPlants = false }
                viewModel.showFavoritesOnly = true
                viewModel.applyFilters()
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.vertical, SeedlyTheme.paddingSmall)
    }
    
    // MARK: - Category Scroll
    private var categoryScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryChip(
                    title: localization.categoryAll,
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    viewModel.selectCategory(nil)
                }
                
                ForEach(viewModel.categories) { category in
                    CategoryChip(
                        title: localization.categoryName(category),
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectCategory(category)
                    }
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
        }
        .padding(.vertical, SeedlyTheme.paddingSmall)
    }
    
    // MARK: - Plants Grid
    private var plantsGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.filteredPlants) { plant in
                NavigationLink(destination: PlantDetailView(plant: plant)) {
                    PlantGridCard(
                        plant: plant,
                        isFavorite: viewModel.isFavorite(plant.id)
                    )
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button {
                        withAnimation { viewModel.toggleFavorite(plant.id) }
                    } label: {
                        Label(
                            viewModel.isFavorite(plant.id) ? localization.removeFromFavorites : localization.addToFavorites,
                            systemImage: viewModel.isFavorite(plant.id) ? "heart.slash" : "heart"
                        )
                    }
                }
            }
            
            // Add plant button — only shown in Favorites tab; tapping switches to All Plants
            if !showAllPlants {
                Button {
                    withAnimation {
                        showAllPlants = true
                        viewModel.showFavoritesOnly = false
                        viewModel.applyFilters()
                    }
                } label: {
                    AddPlantCard(title: localization.browsePlants)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, SeedlyTheme.paddingLarge)
        .padding(.top, SeedlyTheme.paddingSmall)
    }
}

// MARK: - Segment Button

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? SeedlyTheme.primaryGreen : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    SeedlyTheme.primaryGreen.opacity(0.1) :
                    Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? SeedlyTheme.primaryGreen : Color(.systemGray5))
                )
        }
    }
}

// MARK: - Plant Grid Card

struct PlantGridCard: View {
    let plant: Plant
    let isFavorite: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Plant image with emoji
            ZStack {
                PlantImageView(plant: plant, size: 120)
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if isFavorite {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(6)
                        }
                        Spacer()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(plant.localizedName())
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(plantingDateRange())
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func plantingDateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: Date())
        let end = formatter.string(from: Calendar.current.date(byAdding: .month, value: 2, to: Date())!)
        return "\(start) – \(end)"
    }
}

// MARK: - Add Plant Card

struct AddPlantCard: View {
    var title: String = "Add Plant"
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
                .frame(height: 120)
                .overlay(
                    VStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                        Text(title)
                            .font(.system(.caption, design: .rounded, weight: .medium))
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                    }
                )
            
            Spacer()
                .frame(height: 28)
        }
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    PlantsView()
}
