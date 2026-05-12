// PlantsViewModel.swift
// Seedly

import SwiftUI
import Combine

@MainActor
final class PlantsViewModel: ObservableObject {
    @Published var allPlants: [Plant] = []
    @Published var filteredPlants: [Plant] = []
    @Published var searchText = ""
    @Published var selectedCategory: PlantCategory?
    @Published var showFavoritesOnly = false
    
    private let plantDatabase = PlantDatabase.shared
    private let favorites = FavoritesStore.shared
    private var cancellables = Set<AnyCancellable>()
    
    var favoritePlantIds: Set<String> { favorites.favoritePlantIds }
    
    init() {
        loadPlants()
        // Re-apply filters whenever favorites change so the Favorites tab updates
        favorites.$favoritePlantIds
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.showFavoritesOnly { self.applyFilters() }
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadPlants() {
        allPlants = plantDatabase.allPlants
        applyFilters()
    }
    
    func applyFilters() {
        var results = allPlants
        
        if let category = selectedCategory {
            results = results.filter { $0.category == category }
        }
        
        if showFavoritesOnly {
            results = results.filter { favoritePlantIds.contains($0.id) }
        }
        
        if !searchText.isEmpty {
            results = results.filter { plant in
                plant.localizedName().localizedCaseInsensitiveContains(searchText) ||
                plant.scientificName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredPlants = results
    }
    
    func toggleFavorite(_ plantId: String) {
        favorites.toggle(plantId)
    }
    
    func isFavorite(_ plantId: String) -> Bool {
        favorites.isFavorite(plantId)
    }
    
    func selectCategory(_ category: PlantCategory?) {
        selectedCategory = category
        applyFilters()
    }
    
    var categories: [PlantCategory] {
        PlantCategory.allCases
    }
    
    func plantsByCategory() -> [PlantCategory: [Plant]] {
        Dictionary(grouping: filteredPlants, by: { $0.category })
    }
}
