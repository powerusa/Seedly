// GardenStore.swift
// Simple Seeds
//
// Manages the user's personal garden:
// - removedCatalogIds: catalog plants the user removed from their garden
// - customPlants:      plants the user added themselves (with own name/photo/notes)
// - photoData:         keyed by plant id (custom plants only)
//
// All state is persisted in UserDefaults. Photo Data is base64-encoded in the
// custom plant payload so a single UserDefaults key holds everything.

import SwiftUI
import Combine

// MARK: - Custom Plant

struct CustomPlant: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var scientificName: String
    var notes: String
    var categoryRaw: String
    var photoData: Data?
    var dateAdded: Date
    
    var category: PlantCategory {
        PlantCategory(rawValue: categoryRaw) ?? .vegetable
    }
    
    static func new(name: String,
                    scientificName: String,
                    notes: String,
                    category: PlantCategory,
                    photoData: Data?) -> CustomPlant {
        CustomPlant(
            id: "custom_\(UUID().uuidString)",
            name: name,
            scientificName: scientificName,
            notes: notes,
            categoryRaw: category.rawValue,
            photoData: photoData,
            dateAdded: Date()
        )
    }
}

// MARK: - Storage keys (file-level so nonisolated code can read them)

fileprivate let kRemovedKey = "garden.removedCatalogIds"
fileprivate let kCustomKey  = "garden.customPlants"

// MARK: - Garden Store

@MainActor
final class GardenStore: ObservableObject {
    static let shared = GardenStore()
    
    @Published private(set) var removedCatalogIds: Set<String> = []
    @Published private(set) var customPlants: [CustomPlant] = []
    
    private var removedKey: String { kRemovedKey }
    private var customKey: String { kCustomKey }
    
    init() { load() }
    
    // MARK: Catalog management
    
    func isRemoved(_ plantId: String) -> Bool {
        removedCatalogIds.contains(plantId)
    }
    
    func removeFromGarden(_ plantId: String) {
        if plantId.hasPrefix("custom_") {
            customPlants.removeAll { $0.id == plantId }
        } else {
            removedCatalogIds.insert(plantId)
        }
        save()
    }
    
    func restoreToGarden(_ plantId: String) {
        removedCatalogIds.remove(plantId)
        save()
    }
    
    // MARK: Custom plants
    
    func addCustom(_ plant: CustomPlant) {
        customPlants.append(plant)
        save()
    }
    
    func customPlant(withId id: String) -> CustomPlant? {
        customPlants.first { $0.id == id }
    }
    
    func photoData(for plantId: String) -> Data? {
        customPlant(withId: plantId)?.photoData
    }
    
    /// Builds a synthetic `Plant` so a `CustomPlant` can live alongside catalog
    /// entries in the existing grid/detail views.
    func asPlant(_ custom: CustomPlant) -> Plant {
        Plant(
            id: custom.id,
            scientificName: custom.scientificName.isEmpty ? "—" : custom.scientificName,
            category: custom.category,
            difficulty: .beginner,
            frostSensitivity: .tender,
            heatTolerance: .moderate,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 30, betweenRowsCm: 45),
            daysToHarvest: 60...90,
            soilPreferences: [.loamy],
            companionPlants: [],
            incompatiblePlants: [],
            indoorSeedWeeks: nil,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 1.0,
            germinationDays: 7...14,
            optimalTempCelsius: 15...25,
            minSoilTempCelsius: 10,
            imageAssetName: "custom_placeholder",
            nameKey: custom.id,
            descriptionKey: custom.id
        )
    }
    
    // MARK: Persistence
    
    private func load() {
        let saved = UserDefaults.standard.stringArray(forKey: removedKey) ?? []
        removedCatalogIds = Set(saved)
        
        if let data = UserDefaults.standard.data(forKey: customKey),
           let decoded = try? JSONDecoder().decode([CustomPlant].self, from: data) {
            customPlants = decoded
        }
    }
    
    private func save() {
        UserDefaults.standard.set(Array(removedCatalogIds), forKey: removedKey)
        if let data = try? JSONEncoder().encode(customPlants) {
            UserDefaults.standard.set(data, forKey: customKey)
        }
    }
}

// MARK: - Nonisolated reads (safe for any actor)

extension GardenStore {
    /// Reads custom plants straight from UserDefaults so non-MainActor code
    /// (e.g. `Plant.localizedName`) can resolve a user-added plant's name or
    /// photo without crossing actor boundaries.
    nonisolated static func loadCustomPlantsFromDisk() -> [CustomPlant] {
        guard let data = UserDefaults.standard.data(forKey: kCustomKey),
              let decoded = try? JSONDecoder().decode([CustomPlant].self, from: data)
        else { return [] }
        return decoded
    }
    
    nonisolated static func customName(for plantId: String) -> String? {
        loadCustomPlantsFromDisk().first { $0.id == plantId }?.name
    }
    
    nonisolated static func customPhotoData(for plantId: String) -> Data? {
        loadCustomPlantsFromDisk().first { $0.id == plantId }?.photoData
    }
}
