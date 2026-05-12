// Plant.swift
// Seedly

import Foundation
import SwiftUI

struct Plant: Identifiable, Codable, Hashable {
    let id: String
    let scientificName: String
    let category: PlantCategory
    let difficulty: DifficultyLevel
    let frostSensitivity: FrostSensitivity
    let heatTolerance: HeatTolerance
    let waterNeeds: WaterNeeds
    let sunlight: SunlightRequirement
    let spacing: PlantSpacing
    let daysToHarvest: ClosedRange<Int>
    let soilPreferences: [SoilType]
    let companionPlants: [String]
    let incompatiblePlants: [String]
    let indoorSeedWeeks: Int?
    let directSowable: Bool
    let perennial: Bool
    let containerFriendly: Bool
    let greenhouseSuitable: Bool
    let humidityPreference: HumidityPreference
    let plantingDepthCm: Double
    let germinationDays: ClosedRange<Int>
    let optimalTempCelsius: ClosedRange<Double>
    let minSoilTempCelsius: Double
    let imageAssetName: String
    
    // Localization keys
    let nameKey: String
    let descriptionKey: String
    
    func localizedName(for locale: String? = nil) -> String {
        let lang = locale ?? UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        return PlantLocalization.localizedName(for: nameKey, locale: lang)
    }
}

enum PlantCategory: String, Codable, CaseIterable, Identifiable {
    case vegetable
    case fruit
    case herb
    case flower
    case berry
    case tree
    case tropical
    case greenhouse
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .vegetable: return "carrot"
        case .fruit: return "apple.logo"
        case .herb: return "leaf"
        case .flower: return "camera.macro"
        case .berry: return "circle.fill"
        case .tree: return "tree"
        case .tropical: return "sun.max"
        case .greenhouse: return "house"
        }
    }
    
    var displayName: LocalizedStringKey {
        LocalizedStringKey("category_\(rawValue)")
    }
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case expert
    
    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "yellow"
        case .advanced: return "orange"
        case .expert: return "red"
        }
    }
}

enum FrostSensitivity: String, Codable {
    case hardy       // survives frost
    case semiHardy   // tolerates light frost
    case tender      // damaged by frost
    case tropical    // needs warmth always
}

enum HeatTolerance: String, Codable {
    case low         // bolts in heat
    case moderate    // tolerates some heat
    case high        // thrives in heat
    case extreme     // desert-adapted
}

enum WaterNeeds: String, Codable {
    case low
    case moderate
    case high
    case veryHigh
    
    var displayName: LocalizedStringKey {
        LocalizedStringKey("water_\(rawValue)")
    }
}

enum SunlightRequirement: String, Codable {
    case fullSun     // 6+ hours
    case partialSun  // 4-6 hours
    case partialShade // 2-4 hours
    case fullShade   // <2 hours
    
    var hours: String {
        switch self {
        case .fullSun: return "6-8h"
        case .partialSun: return "4-6h"
        case .partialShade: return "2-4h"
        case .fullShade: return "1-2h"
        }
    }
}

struct PlantSpacing: Codable, Hashable {
    let betweenPlantsCm: Double
    let betweenRowsCm: Double
}

enum SoilType: String, Codable {
    case sandy
    case loamy
    case clay
    case chalky
    case peat
    case silt
    case wellDrained
    case moistRetentive
    case rich
}

enum HumidityPreference: String, Codable {
    case low
    case moderate
    case high
    case veryHigh
}

// MARK: - Planting Window
struct PlantingWindow: Codable, Hashable {
    let plantId: String
    let climateZoneId: String
    let indoorSowStart: MonthWeek?
    let indoorSowEnd: MonthWeek?
    let outdoorSowStart: MonthWeek
    let outdoorSowEnd: MonthWeek
    let transplantStart: MonthWeek?
    let transplantEnd: MonthWeek?
    let harvestStart: MonthWeek
    let harvestEnd: MonthWeek
}

struct MonthWeek: Codable, Hashable, Comparable {
    let month: Int  // 1-12
    let week: Int   // 1-4
    
    static func < (lhs: MonthWeek, rhs: MonthWeek) -> Bool {
        if lhs.month == rhs.month {
            return lhs.week < rhs.week
        }
        return lhs.month < rhs.month
    }
    
    var displayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let calendar = Calendar.current
        let date = calendar.date(from: DateComponents(month: month))!
        return "\(formatter.string(from: date)) \(week)"
    }
}
