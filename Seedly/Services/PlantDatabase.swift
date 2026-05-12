// PlantDatabase.swift
// Seedly

import Foundation

final class PlantDatabase {
    
    static let shared = PlantDatabase()
    
    private(set) var allPlants: [Plant] = []
    
    private init() {
        loadPlants()
    }
    
    // MARK: - Load
    private func loadPlants() {
        allPlants = Self.mockPlants + Self.expansionPlants + Self.fullPlantList
    }
    
    // MARK: - Query
    func plants(for category: PlantCategory) -> [Plant] {
        allPlants.filter { $0.category == category }
    }
    
    func plant(byId id: String) -> Plant? {
        allPlants.first { $0.id == id }
    }
    
    func search(query: String) -> [Plant] {
        let lowercased = query.lowercased()
        return allPlants.filter { plant in
            plant.localizedName().lowercased().contains(lowercased) ||
            plant.scientificName.lowercased().contains(lowercased) ||
            plant.category.rawValue.contains(lowercased)
        }
    }
    
    func beginnerFriendly() -> [Plant] {
        allPlants.filter { $0.difficulty == .beginner }
    }
    
    func frostHardy() -> [Plant] {
        allPlants.filter { $0.frostSensitivity == .hardy || $0.frostSensitivity == .semiHardy }
    }
    
    func containerFriendly() -> [Plant] {
        allPlants.filter { $0.containerFriendly }
    }
    
    // MARK: - Mock Data
    static let mockPlants: [Plant] = [
        Plant(
            id: "tomato",
            scientificName: "Solanum lycopersicum",
            category: .vegetable,
            difficulty: .beginner,
            frostSensitivity: .tender,
            heatTolerance: .high,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 60, betweenRowsCm: 90),
            daysToHarvest: 70...85,
            soilPreferences: [.loamy, .wellDrained, .rich],
            companionPlants: ["basil", "carrot", "parsley"],
            incompatiblePlants: ["cabbage", "fennel"],
            indoorSeedWeeks: 6,
            directSowable: false,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0.6,
            germinationDays: 5...10,
            optimalTempCelsius: 18...30,
            minSoilTempCelsius: 16,
            imageAssetName: "plant_tomato",
            nameKey: "plant_tomato",
            descriptionKey: "plant_tomato_desc"
        ),
        Plant(
            id: "carrot",
            scientificName: "Daucus carota",
            category: .vegetable,
            difficulty: .beginner,
            frostSensitivity: .semiHardy,
            heatTolerance: .moderate,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 5, betweenRowsCm: 30),
            daysToHarvest: 60...80,
            soilPreferences: [.sandy, .loamy, .wellDrained],
            companionPlants: ["tomato", "onion", "lettuce"],
            incompatiblePlants: ["dill"],
            indoorSeedWeeks: nil,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0.6,
            germinationDays: 10...14,
            optimalTempCelsius: 7...24,
            minSoilTempCelsius: 7,
            imageAssetName: "plant_carrot",
            nameKey: "plant_carrot",
            descriptionKey: "plant_carrot_desc"
        ),
        Plant(
            id: "lettuce",
            scientificName: "Lactuca sativa",
            category: .vegetable,
            difficulty: .beginner,
            frostSensitivity: .semiHardy,
            heatTolerance: .low,
            waterNeeds: .high,
            sunlight: .partialSun,
            spacing: PlantSpacing(betweenPlantsCm: 25, betweenRowsCm: 30),
            daysToHarvest: 30...60,
            soilPreferences: [.loamy, .rich, .moistRetentive],
            companionPlants: ["carrot", "radish", "strawberry"],
            incompatiblePlants: [],
            indoorSeedWeeks: 4,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0.3,
            germinationDays: 5...10,
            optimalTempCelsius: 10...20,
            minSoilTempCelsius: 4,
            imageAssetName: "plant_lettuce",
            nameKey: "plant_lettuce",
            descriptionKey: "plant_lettuce_desc"
        ),
        Plant(
            id: "basil",
            scientificName: "Ocimum basilicum",
            category: .herb,
            difficulty: .beginner,
            frostSensitivity: .tender,
            heatTolerance: .high,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 25, betweenRowsCm: 40),
            daysToHarvest: 50...70,
            soilPreferences: [.loamy, .wellDrained, .rich],
            companionPlants: ["tomato", "pepper"],
            incompatiblePlants: ["sage"],
            indoorSeedWeeks: 6,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0.3,
            germinationDays: 5...10,
            optimalTempCelsius: 20...30,
            minSoilTempCelsius: 15,
            imageAssetName: "plant_basil",
            nameKey: "plant_basil",
            descriptionKey: "plant_basil_desc"
        ),
        Plant(
            id: "pepper",
            scientificName: "Capsicum annuum",
            category: .vegetable,
            difficulty: .intermediate,
            frostSensitivity: .tender,
            heatTolerance: .high,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 45, betweenRowsCm: 60),
            daysToHarvest: 60...90,
            soilPreferences: [.loamy, .wellDrained, .rich],
            companionPlants: ["tomato", "basil", "carrot"],
            incompatiblePlants: ["fennel"],
            indoorSeedWeeks: 8,
            directSowable: false,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0.6,
            germinationDays: 7...14,
            optimalTempCelsius: 20...32,
            minSoilTempCelsius: 18,
            imageAssetName: "plant_pepper",
            nameKey: "plant_pepper",
            descriptionKey: "plant_pepper_desc"
        ),
        Plant(
            id: "cucumber",
            scientificName: "Cucumis sativus",
            category: .vegetable,
            difficulty: .beginner,
            frostSensitivity: .tender,
            heatTolerance: .moderate,
            waterNeeds: .high,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 45, betweenRowsCm: 120),
            daysToHarvest: 50...70,
            soilPreferences: [.loamy, .rich, .wellDrained],
            companionPlants: ["bean", "corn", "sunflower"],
            incompatiblePlants: ["potato", "sage"],
            indoorSeedWeeks: 3,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .high,
            plantingDepthCm: 2.0,
            germinationDays: 3...10,
            optimalTempCelsius: 18...30,
            minSoilTempCelsius: 16,
            imageAssetName: "plant_cucumber",
            nameKey: "plant_cucumber",
            descriptionKey: "plant_cucumber_desc"
        ),
        Plant(
            id: "strawberry",
            scientificName: "Fragaria × ananassa",
            category: .berry,
            difficulty: .beginner,
            frostSensitivity: .semiHardy,
            heatTolerance: .moderate,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 30, betweenRowsCm: 60),
            daysToHarvest: 60...90,
            soilPreferences: [.loamy, .wellDrained, .rich],
            companionPlants: ["lettuce", "spinach", "onion"],
            incompatiblePlants: ["cabbage"],
            indoorSeedWeeks: nil,
            directSowable: false,
            perennial: true,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 0,
            germinationDays: 14...28,
            optimalTempCelsius: 15...26,
            minSoilTempCelsius: 10,
            imageAssetName: "plant_strawberry",
            nameKey: "plant_strawberry",
            descriptionKey: "plant_strawberry_desc"
        ),
        Plant(
            id: "spinach",
            scientificName: "Spinacia oleracea",
            category: .vegetable,
            difficulty: .beginner,
            frostSensitivity: .hardy,
            heatTolerance: .low,
            waterNeeds: .moderate,
            sunlight: .partialSun,
            spacing: PlantSpacing(betweenPlantsCm: 15, betweenRowsCm: 30),
            daysToHarvest: 35...50,
            soilPreferences: [.loamy, .rich, .moistRetentive],
            companionPlants: ["strawberry", "pea"],
            incompatiblePlants: [],
            indoorSeedWeeks: nil,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .moderate,
            plantingDepthCm: 1.5,
            germinationDays: 5...14,
            optimalTempCelsius: 5...20,
            minSoilTempCelsius: 2,
            imageAssetName: "plant_spinach",
            nameKey: "plant_spinach",
            descriptionKey: "plant_spinach_desc"
        ),
        Plant(
            id: "onion",
            scientificName: "Allium cepa",
            category: .vegetable,
            difficulty: .intermediate,
            frostSensitivity: .hardy,
            heatTolerance: .moderate,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 10, betweenRowsCm: 30),
            daysToHarvest: 90...120,
            soilPreferences: [.loamy, .wellDrained],
            companionPlants: ["carrot", "lettuce", "strawberry"],
            incompatiblePlants: ["bean", "pea"],
            indoorSeedWeeks: 8,
            directSowable: true,
            perennial: false,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .low,
            plantingDepthCm: 1.5,
            germinationDays: 7...14,
            optimalTempCelsius: 13...24,
            minSoilTempCelsius: 2,
            imageAssetName: "plant_onion",
            nameKey: "plant_onion",
            descriptionKey: "plant_onion_desc"
        ),
        Plant(
            id: "sunflower",
            scientificName: "Helianthus annuus",
            category: .flower,
            difficulty: .beginner,
            frostSensitivity: .tender,
            heatTolerance: .high,
            waterNeeds: .moderate,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 45, betweenRowsCm: 75),
            daysToHarvest: 70...100,
            soilPreferences: [.loamy, .wellDrained],
            companionPlants: ["cucumber", "corn"],
            incompatiblePlants: ["potato"],
            indoorSeedWeeks: nil,
            directSowable: true,
            perennial: false,
            containerFriendly: false,
            greenhouseSuitable: false,
            humidityPreference: .low,
            plantingDepthCm: 2.5,
            germinationDays: 7...14,
            optimalTempCelsius: 18...30,
            minSoilTempCelsius: 10,
            imageAssetName: "plant_sunflower",
            nameKey: "plant_sunflower",
            descriptionKey: "plant_sunflower_desc"
        ),
        Plant(
            id: "mint",
            scientificName: "Mentha spicata",
            category: .herb,
            difficulty: .beginner,
            frostSensitivity: .hardy,
            heatTolerance: .moderate,
            waterNeeds: .high,
            sunlight: .partialSun,
            spacing: PlantSpacing(betweenPlantsCm: 45, betweenRowsCm: 60),
            daysToHarvest: 60...90,
            soilPreferences: [.loamy, .moistRetentive, .rich],
            companionPlants: ["tomato", "cabbage"],
            incompatiblePlants: ["parsley"],
            indoorSeedWeeks: nil,
            directSowable: true,
            perennial: true,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .high,
            plantingDepthCm: 0.3,
            germinationDays: 10...15,
            optimalTempCelsius: 13...21,
            minSoilTempCelsius: 5,
            imageAssetName: "plant_mint",
            nameKey: "plant_mint",
            descriptionKey: "plant_mint_desc"
        ),
        Plant(
            id: "lavender",
            scientificName: "Lavandula angustifolia",
            category: .flower,
            difficulty: .intermediate,
            frostSensitivity: .semiHardy,
            heatTolerance: .high,
            waterNeeds: .low,
            sunlight: .fullSun,
            spacing: PlantSpacing(betweenPlantsCm: 45, betweenRowsCm: 60),
            daysToHarvest: 90...200,
            soilPreferences: [.sandy, .wellDrained, .chalky],
            companionPlants: ["rosemary", "thyme"],
            incompatiblePlants: [],
            indoorSeedWeeks: 10,
            directSowable: false,
            perennial: true,
            containerFriendly: true,
            greenhouseSuitable: true,
            humidityPreference: .low,
            plantingDepthCm: 0.3,
            germinationDays: 14...28,
            optimalTempCelsius: 15...25,
            minSoilTempCelsius: 5,
            imageAssetName: "plant_lavender",
            nameKey: "plant_lavender",
            descriptionKey: "plant_lavender_desc"
        )
    ]
}
