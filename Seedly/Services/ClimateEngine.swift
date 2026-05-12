// ClimateEngine.swift
// Seedly

import Foundation

final class ClimateEngine {
    
    // MARK: - Zone Determination
    func determineZone(for location: GardenLocation) -> ClimateZone {
        let koppen = classifyKoppen(latitude: location.latitude, longitude: location.longitude)
        let usda = estimateUSDAZone(latitude: location.latitude, longitude: location.longitude)
        let frostDates = estimateFrostDates(for: location)
        
        return ClimateZone(
            id: "\(koppen.rawValue)_\(Int(location.latitude))_\(Int(location.longitude))",
            name: koppen.description,
            usdaZone: usda,
            koppenClass: koppen,
            hemisphere: location.hemisphere,
            averageFirstFrost: frostDates.first,
            averageLastFrost: frostDates.last,
            growingSeasonWeeks: calculateGrowingSeason(koppen: koppen, latitude: location.latitude),
            annualRainfallMm: estimateRainfall(koppen: koppen),
            avgSummerHighC: estimateSummerHigh(koppen: koppen, latitude: location.latitude),
            avgWinterLowC: estimateWinterLow(koppen: koppen, latitude: location.latitude)
        )
    }
    
    // MARK: - Köppen Classification (simplified)
    private func classifyKoppen(latitude: Double, longitude: Double) -> KoppenClimate {
        let absLat = abs(latitude)
        
        if absLat < 10 { return .af }
        if absLat < 20 { return .aw }
        if absLat < 30 {
            // Check for arid regions (simplified)
            if isLikelyArid(latitude: latitude, longitude: longitude) {
                return .bwh
            }
            return .cfa
        }
        if absLat < 40 {
            if isMediterranean(latitude: latitude, longitude: longitude) {
                return .csa
            }
            return .cfb
        }
        if absLat < 50 { return .dfb }
        if absLat < 60 { return .dfc }
        return .et
    }
    
    private func isLikelyArid(latitude: Double, longitude: Double) -> Bool {
        // Simplified arid detection based on known desert regions
        let absLat = abs(latitude)
        if absLat > 15 && absLat < 35 {
            // Sahara, Arabian, Australian interior, Sonoran
            if (longitude > -10 && longitude < 60 && latitude > 15 && latitude < 35) { return true }
            if (longitude > 110 && longitude < 150 && latitude < -20) { return true }
            if (longitude > -120 && longitude < -100 && latitude > 25 && latitude < 35) { return true }
        }
        return false
    }
    
    private func isMediterranean(latitude: Double, longitude: Double) -> Bool {
        // Simplified Mediterranean detection
        if latitude > 30 && latitude < 45 {
            if longitude > -10 && longitude < 40 { return true }
            if longitude > -125 && longitude < -115 && latitude > 32 && latitude < 42 { return true }
        }
        return false
    }
    
    // MARK: - USDA Zone Estimation
    private func estimateUSDAZone(latitude: Double, longitude: Double) -> String {
        let absLat = abs(latitude)
        
        if absLat < 10 { return "13a" }
        if absLat < 15 { return "12a" }
        if absLat < 20 { return "11a" }
        if absLat < 25 { return "10a" }
        if absLat < 30 { return "9a" }
        if absLat < 35 { return "8a" }
        if absLat < 38 { return "7b" }
        if absLat < 40 { return "7a" }
        if absLat < 42 { return "6b" }
        if absLat < 44 { return "6a" }
        if absLat < 46 { return "5b" }
        if absLat < 48 { return "5a" }
        if absLat < 50 { return "4b" }
        if absLat < 55 { return "4a" }
        if absLat < 60 { return "3a" }
        return "2a"
    }
    
    // MARK: - Frost Date Estimation
    private func estimateFrostDates(for location: GardenLocation) -> (first: MonthWeek?, last: MonthWeek?) {
        let koppen = classifyKoppen(latitude: location.latitude, longitude: location.longitude)
        
        if koppen.isTropical { return (nil, nil) }
        
        let absLat = abs(location.latitude)
        let isNorthern = location.hemisphere == .northern
        
        // Estimate based on latitude
        let lastFrostMonth: Int
        let firstFrostMonth: Int
        
        if absLat < 30 {
            lastFrostMonth = isNorthern ? 2 : 8
            firstFrostMonth = isNorthern ? 12 : 6
        } else if absLat < 35 {
            lastFrostMonth = isNorthern ? 3 : 9
            firstFrostMonth = isNorthern ? 11 : 5
        } else if absLat < 40 {
            lastFrostMonth = isNorthern ? 4 : 10
            firstFrostMonth = isNorthern ? 10 : 4
        } else if absLat < 45 {
            lastFrostMonth = isNorthern ? 4 : 10
            firstFrostMonth = isNorthern ? 10 : 4
        } else if absLat < 50 {
            lastFrostMonth = isNorthern ? 5 : 11
            firstFrostMonth = isNorthern ? 9 : 3
        } else {
            lastFrostMonth = isNorthern ? 5 : 11
            firstFrostMonth = isNorthern ? 9 : 3
        }
        
        return (
            first: MonthWeek(month: firstFrostMonth, week: 2),
            last: MonthWeek(month: lastFrostMonth, week: 3)
        )
    }
    
    // MARK: - Growing Season
    private func calculateGrowingSeason(koppen: KoppenClimate, latitude: Double) -> Int {
        if koppen.isTropical { return 52 }
        if koppen.isArid { return 40 }
        
        let absLat = abs(latitude)
        if absLat < 30 { return 44 }
        if absLat < 35 { return 36 }
        if absLat < 40 { return 30 }
        if absLat < 45 { return 24 }
        if absLat < 50 { return 20 }
        if absLat < 55 { return 16 }
        return 12
    }
    
    // MARK: - Rainfall Estimation
    private func estimateRainfall(koppen: KoppenClimate) -> Double {
        switch koppen {
        case .af: return 2000
        case .am: return 1800
        case .aw: return 1200
        case .bwh, .bwk: return 150
        case .bsh, .bsk: return 400
        case .cfa: return 1200
        case .cfb: return 800
        case .cfc: return 1000
        case .csa, .csb: return 500
        case .cwa, .cwb: return 1100
        case .dfa: return 900
        case .dfb: return 700
        case .dfc: return 500
        case .dwa, .dwb: return 600
        case .et: return 250
        case .ef: return 100
        }
    }
    
    // MARK: - Temperature Estimation
    private func estimateSummerHigh(koppen: KoppenClimate, latitude: Double) -> Double {
        switch koppen {
        case .af, .am: return 32
        case .aw: return 35
        case .bwh: return 42
        case .bwk: return 35
        case .bsh: return 38
        case .bsk: return 32
        case .cfa: return 33
        case .cfb: return 22
        case .cfc: return 16
        case .csa: return 35
        case .csb: return 28
        case .cwa, .cwb: return 30
        case .dfa: return 30
        case .dfb: return 25
        case .dfc: return 18
        case .dwa, .dwb: return 28
        case .et: return 10
        case .ef: return 0
        }
    }
    
    private func estimateWinterLow(koppen: KoppenClimate, latitude: Double) -> Double {
        switch koppen {
        case .af, .am: return 22
        case .aw: return 18
        case .bwh: return 10
        case .bwk: return -5
        case .bsh: return 8
        case .bsk: return -2
        case .cfa: return 2
        case .cfb: return 2
        case .cfc: return -2
        case .csa: return 5
        case .csb: return 3
        case .cwa, .cwb: return 5
        case .dfa: return -10
        case .dfb: return -15
        case .dfc: return -30
        case .dwa, .dwb: return -20
        case .et: return -30
        case .ef: return -50
        }
    }
    
    // MARK: - Seasonal Detection
    func currentSeason(for location: GardenLocation) -> Season {
        let month = Calendar.current.component(.month, from: Date())
        let isNorthern = location.hemisphere == .northern
        
        switch month {
        case 3, 4, 5: return isNorthern ? .spring : .autumn
        case 6, 7, 8: return isNorthern ? .summer : .winter
        case 9, 10, 11: return isNorthern ? .autumn : .spring
        default: return isNorthern ? .winter : .summer
        }
    }
    
    // MARK: - Planting Safety
    func isPlantingSafe(for plant: Plant, at location: GardenLocation, weather: WeatherData?) -> PlantingSafety {
        guard let weather = weather else { return .unknown }
        
        if weather.lowTemp < plant.minSoilTempCelsius {
            return .unsafe(reason: "Too cold for \(plant.localizedName())")
        }
        
        if weather.hasFrostRisk && plant.frostSensitivity == .tender {
            return .risky(reason: "Frost risk for sensitive plants")
        }
        
        if weather.hasHeatRisk && plant.heatTolerance == .low {
            return .risky(reason: "Heat stress risk")
        }
        
        if weather.currentTemp >= plant.optimalTempCelsius.lowerBound &&
           weather.currentTemp <= plant.optimalTempCelsius.upperBound {
            return .excellent
        }
        
        return .safe
    }
}

enum Season: String, CaseIterable {
    case spring
    case summer
    case autumn
    case winter
    
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .autumn: return "leaf.arrow.triangle.circlepath"
        case .winter: return "snowflake"
        }
    }
    
    var gradientColors: [String] {
        switch self {
        case .spring: return ["mint", "green"]
        case .summer: return ["yellow", "orange"]
        case .autumn: return ["orange", "brown"]
        case .winter: return ["blue", "indigo"]
        }
    }
}

enum PlantingSafety {
    case excellent
    case safe
    case risky(reason: String)
    case unsafe(reason: String)
    case unknown
    
    var displayName: String {
        switch self {
        case .excellent: return "Excellent"
        case .safe: return "Safe"
        case .risky: return "Risky"
        case .unsafe: return "Unsafe"
        case .unknown: return "Unknown"
        }
    }
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .safe: return "teal"
        case .risky: return "orange"
        case .unsafe: return "red"
        case .unknown: return "gray"
        }
    }
}
