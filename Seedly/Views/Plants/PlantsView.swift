// PlantsView.swift
// Seedly

import SwiftUI

struct PlantsView: View {
    @StateObject private var viewModel = PlantsViewModel()
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var garden: GardenStore
    @State private var showAllPlants = true
    @State private var isEditing = false
    @State private var showAddSheet = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    // Plants visible after applying garden filters (removed catalog + custom)
    private var visiblePlants: [Plant] {
        let filtered = viewModel.filteredPlants.filter { !garden.isRemoved($0.id) }
        let customAsPlants = garden.customPlants.map { garden.asPlant($0) }
        // When viewing favorites, custom plants are not shown unless favorited.
        let customs = viewModel.showFavoritesOnly
            ? customAsPlants.filter { viewModel.isFavorite($0.id) }
            : customAsPlants.filter { plant in
                if let cat = viewModel.selectedCategory { return plant.category == cat }
                return true
            }
        return filtered + customs
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                segmentedControl
                categoryScroll
                ScrollView {
                    plantsGrid
                        .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localization.myGarden)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(SeedlyTheme.primaryGreen)
                    }
                    .accessibilityLabel(localization.addPlant)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? localization.done : localization.edit) {
                        withAnimation { isEditing.toggle() }
                    }
                    .foregroundStyle(SeedlyTheme.primaryGreen)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: localization.searchPlants)
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.applyFilters()
            }
            .sheet(isPresented: $showAddSheet) {
                AddCustomPlantSheet()
                    .environmentObject(localization)
                    .environmentObject(garden)
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
            ForEach(visiblePlants) { plant in
                ZStack(alignment: .topLeading) {
                    NavigationLink(destination: PlantDetailView(plant: plant)) {
                        PlantGridCard(
                            plant: plant,
                            isFavorite: viewModel.isFavorite(plant.id)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isEditing)
                    .contextMenu {
                        Button {
                            withAnimation { viewModel.toggleFavorite(plant.id) }
                        } label: {
                            Label(
                                viewModel.isFavorite(plant.id) ? localization.removeFromFavorites : localization.addToFavorites,
                                systemImage: viewModel.isFavorite(plant.id) ? "heart.slash" : "heart"
                            )
                        }
                        Button(role: .destructive) {
                            withAnimation { garden.removeFromGarden(plant.id) }
                        } label: {
                            Label(localization.removeFromGarden, systemImage: "trash")
                        }
                    }
                    
                    if isEditing {
                        Button {
                            withAnimation { garden.removeFromGarden(plant.id) }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .red)
                                .background(Circle().fill(.white).scaleEffect(0.8))
                        }
                        .offset(x: -6, y: -6)
                        .accessibilityLabel(localization.removeFromGarden)
                    }
                }
            }
            
            // Add custom plant card — visible in both tabs
            Button {
                showAddSheet = true
            } label: {
                AddPlantCard(title: localization.addPlant)
            }
            .buttonStyle(.plain)
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
