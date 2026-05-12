// PlantingEngine.swift
// Seedly

import Foundation
import SwiftUI

final class PlantingEngine {
    
    private let climateEngine = ClimateEngine()
    
    // MARK: - Planting Window Calculation
    func calculatePlantingWindow(
        for plant: Plant,
        in zone: ClimateZone,
        weather: WeatherData?
    ) -> PlantingSchedule {
        let hemisphere = zone.hemisphere
        let today = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: today)
        
        // Calculate indoor seed start date
        let indoorStartDate = calculateIndoorSeedDate(plant: plant, zone: zone)
        
        // Calculate outdoor transplant/sow date
        let outdoorDate = calculateOutdoorDate(plant: plant, zone: zone)
        
        // Calculate harvest date
        let harvestDate = calculateHarvestDate(plant: plant, plantingDate: outdoorDate)
        
        // Determine current status
        let status = determineCurrentStatus(
            plant: plant,
            indoorStart: indoorStartDate,
            outdoorDate: outdoorDate,
            harvestDate: harvestDate,
            today: today
        )
        
        // Calculate days until safe to plant
        let daysUntilSafe = calculateDaysUntilSafe(
            plant: plant,
            zone: zone,
            weather: weather
        )
        
        return PlantingSchedule(
            plant: plant,
            indoorSeedStart: indoorStartDate,
            outdoorPlantDate: outdoorDate,
            expectedHarvestDate: harvestDate,
            currentStatus: status,
            daysUntilSafePlanting: daysUntilSafe,
            isInPlantingWindow: status == .readyToPlant || status == .inProgress
        )
    }
    
    // MARK: - Indoor Seed Calculation
    private func calculateIndoorSeedDate(plant: Plant, zone: ClimateZone) -> Date? {
        guard let indoorWeeks = plant.indoorSeedWeeks else { return nil }
        guard let lastFrost = zone.averageLastFrost else { return nil }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        // Last frost date
        var components = DateComponents()
        components.year = year
        components.month = lastFrost.month
        components.weekOfMonth = lastFrost.week
        
        guard let frostDate = calendar.date(from: components) else { return nil }
        
        // Subtract indoor weeks
        return calendar.date(byAdding: .weekOfYear, value: -indoorWeeks, to: frostDate)
    }
    
    // MARK: - Outdoor Date Calculation
    private func calculateOutdoorDate(plant: Plant, zone: ClimateZone) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        
        if zone.koppenClass.isTropical {
            // Tropical: can plant year-round, return current date or next suitable date
            return Date()
        }
        
        guard let lastFrost = zone.averageLastFrost else {
            return Date()
        }
        
        var components = DateComponents()
        components.year = year
        components.month = lastFrost.month
        components.weekOfMonth = lastFrost.week
        
        guard let frostDate = calendar.date(from: components) else { return Date() }
        
        // Add buffer based on frost sensitivity
        let bufferWeeks: Int
        switch plant.frostSensitivity {
        case .hardy: bufferWeeks = -2
        case .semiHardy: bufferWeeks = 0
        case .tender: bufferWeeks = 2
        case .tropical: bufferWeeks = 4
        }
        
        return calendar.date(byAdding: .weekOfYear, value: bufferWeeks, to: frostDate) ?? frostDate
    }
    
    // MARK: - Harvest Calculation
    private func calculateHarvestDate(plant: Plant, plantingDate: Date) -> Date {
        let calendar = Calendar.current
        let avgDays = (plant.daysToHarvest.lowerBound + plant.daysToHarvest.upperBound) / 2
        return calendar.date(byAdding: .day, value: avgDays, to: plantingDate) ?? plantingDate
    }
    
    // MARK: - Status Determination
    private func determineCurrentStatus(
        plant: Plant,
        indoorStart: Date?,
        outdoorDate: Date,
        harvestDate: Date,
        today: Date
    ) -> PlantingStatus {
        let calendar = Calendar.current
        
        // Check if we're in indoor seed starting window
        if let indoorStart = indoorStart {
            let indoorEnd = calendar.date(byAdding: .weekOfYear, value: 2, to: indoorStart)!
            if today >= indoorStart && today <= indoorEnd {
                return .startIndoors
            }
        }
        
        // Check if we're approaching planting
        let twoWeeksBefore = calendar.date(byAdding: .weekOfYear, value: -2, to: outdoorDate)!
        if today >= twoWeeksBefore && today < outdoorDate {
            return .approaching
        }
        
        // Check if we're in the planting window
        let plantingWindowEnd = calendar.date(byAdding: .weekOfYear, value: 4, to: outdoorDate)!
        if today >= outdoorDate && today <= plantingWindowEnd {
            return .readyToPlant
        }
        
        // Check if growing
        if today > plantingWindowEnd && today < harvestDate {
            return .inProgress
        }
        
        // Check if harvesting
        let harvestWindowEnd = calendar.date(byAdding: .weekOfYear, value: 4, to: harvestDate)!
        if today >= harvestDate && today <= harvestWindowEnd {
            return .harvesting
        }
        
        // Off-season
        if today > harvestWindowEnd || today < (indoorStart ?? twoWeeksBefore) {
            return .offSeason
        }
        
        return .offSeason
    }
    
    // MARK: - Days Until Safe
    private func calculateDaysUntilSafe(
        plant: Plant,
        zone: ClimateZone,
        weather: WeatherData?
    ) -> Int? {
        let outdoorDate = calculateOutdoorDate(plant: plant, zone: zone)
        let today = Date()
        
        if outdoorDate <= today { return 0 }
        
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: today, to: outdoorDate).day
    }
    
    // MARK: - Today's Recommendations
    func todayRecommendations(
        plants: [Plant],
        zone: ClimateZone,
        weather: WeatherData?
    ) -> [PlantRecommendation] {
        var recommendations: [PlantRecommendation] = []
        
        for plant in plants {
            let schedule = calculatePlantingWindow(for: plant, in: zone, weather: weather)
            
            switch schedule.currentStatus {
            case .readyToPlant:
                let safety = climateEngine.isPlantingSafe(for: plant, at: GardenLocation(
                    latitude: 0, longitude: 0, city: "", country: "", timeZone: .current
                ), weather: weather)
                recommendations.append(PlantRecommendation(
                    plant: plant,
                    action: .plantNow,
                    reason: "Perfect time to plant",
                    safety: safety
                ))
            case .startIndoors:
                recommendations.append(PlantRecommendation(
                    plant: plant,
                    action: .startIndoors,
                    reason: "Start seeds indoors this week",
                    safety: .safe
                ))
            case .approaching:
                if let days = schedule.daysUntilSafePlanting {
                    recommendations.append(PlantRecommendation(
                        plant: plant,
                        action: .waitToPlant,
                        reason: "Safe to plant in \(days) days",
                        safety: .safe
                    ))
                }
            case .harvesting:
                recommendations.append(PlantRecommendation(
                    plant: plant,
                    action: .harvest,
                    reason: "Ready to harvest",
                    safety: .excellent
                ))
            default:
                break
            }
        }
        
        return recommendations.sorted { $0.safety.sortOrder < $1.safety.sortOrder }
    }
    
    // MARK: - Watering Schedule
    func wateringRecommendation(
        for plant: Plant,
        weather: WeatherData?,
        season: Season
    ) -> WateringRecommendation {
        guard let weather = weather else {
            return WateringRecommendation(
                shouldWater: true,
                reason: "Check soil moisture",
                nextWateringDays: 1
            )
        }
        
        // Skip watering if significant rain expected
        if weather.hasRainExpected && weather.precipitationMm > 5 {
            return WateringRecommendation(
                shouldWater: false,
                reason: "Rain expected — skip watering",
                nextWateringDays: 2
            )
        }
        
        // Increase watering in heat
        if weather.hasHeatRisk {
            return WateringRecommendation(
                shouldWater: true,
                reason: "High heat — water deeply",
                nextWateringDays: 1
            )
        }
        
        // Normal schedule based on plant needs
        let interval: Int
        switch plant.waterNeeds {
        case .veryHigh: interval = 1
        case .high: interval = 2
        case .moderate: interval = 3
        case .low: interval = 5
        }
        
        return WateringRecommendation(
            shouldWater: true,
            reason: "Regular watering schedule",
            nextWateringDays: interval
        )
    }
}

// MARK: - Supporting Types

struct PlantingSchedule {
    let plant: Plant
    let indoorSeedStart: Date?
    let outdoorPlantDate: Date
    let expectedHarvestDate: Date
    let currentStatus: PlantingStatus
    let daysUntilSafePlanting: Int?
    let isInPlantingWindow: Bool
}

enum PlantingStatus: String {
    case offSeason
    case startIndoors
    case approaching
    case readyToPlant
    case inProgress
    case harvesting
    
    var displayName: LocalizedStringKey {
        LocalizedStringKey("status_\(rawValue)")
    }
    
    var icon: String {
        switch self {
        case .offSeason: return "moon.zzz"
        case .startIndoors: return "house.fill"
        case .approaching: return "clock"
        case .readyToPlant: return "checkmark.circle.fill"
        case .inProgress: return "arrow.up.circle.fill"
        case .harvesting: return "basket.fill"
        }
    }
}

struct PlantRecommendation: Identifiable {
    let id = UUID()
    let plant: Plant
    let action: RecommendedAction
    let reason: String
    let safety: PlantingSafety
}

enum RecommendedAction {
    case plantNow
    case startIndoors
    case waitToPlant
    case harvest
    case protect
    
    var icon: String {
        switch self {
        case .plantNow: return "leaf.fill"
        case .startIndoors: return "house.fill"
        case .waitToPlant: return "clock.fill"
        case .harvest: return "basket.fill"
        case .protect: return "shield.fill"
        }
    }
}

struct WateringRecommendation {
    let shouldWater: Bool
    let reason: String
    let nextWateringDays: Int
}

// MARK: - PlantingSafety Extension
extension PlantingSafety {
    var sortOrder: Int {
        switch self {
        case .excellent: return 0
        case .safe: return 1
        case .risky: return 2
        case .unsafe: return 3
        case .unknown: return 4
        }
    }
}
