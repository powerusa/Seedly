// ClimateZone.swift
// Seedly

import Foundation

struct ClimateZone: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let usdaZone: String?
    let koppenClass: KoppenClimate
    let hemisphere: Hemisphere
    let averageFirstFrost: MonthWeek?
    let averageLastFrost: MonthWeek?
    let growingSeasonWeeks: Int
    let annualRainfallMm: Double
    let avgSummerHighC: Double
    let avgWinterLowC: Double
}

enum Hemisphere: String, Codable {
    case northern
    case southern
    case tropical
}

enum KoppenClimate: String, Codable, CaseIterable {
    // Tropical
    case af = "Af"   // Tropical rainforest
    case am = "Am"   // Tropical monsoon
    case aw = "Aw"   // Tropical savanna
    
    // Arid
    case bwh = "BWh" // Hot desert
    case bwk = "BWk" // Cold desert
    case bsh = "BSh" // Hot semi-arid
    case bsk = "BSk" // Cold semi-arid
    
    // Temperate
    case cfa = "Cfa"  // Humid subtropical
    case cfb = "Cfb"  // Oceanic
    case cfc = "Cfc"  // Subpolar oceanic
    case csa = "Csa"  // Hot-summer Mediterranean
    case csb = "Csb"  // Warm-summer Mediterranean
    case cwa = "Cwa"  // Monsoon-influenced humid subtropical
    case cwb = "Cwb"  // Subtropical highland
    
    // Continental
    case dfa = "Dfa"  // Hot-summer humid continental
    case dfb = "Dfb"  // Warm-summer humid continental
    case dfc = "Dfc"  // Subarctic
    case dwa = "Dwa"  // Monsoon-influenced hot-summer continental
    case dwb = "Dwb"  // Monsoon-influenced warm-summer continental
    
    // Polar
    case et = "ET"    // Tundra
    case ef = "EF"    // Ice cap
    
    var description: String {
        switch self {
        case .af: return "Tropical Rainforest"
        case .am: return "Tropical Monsoon"
        case .aw: return "Tropical Savanna"
        case .bwh: return "Hot Desert"
        case .bwk: return "Cold Desert"
        case .bsh: return "Hot Semi-Arid"
        case .bsk: return "Cold Semi-Arid"
        case .cfa: return "Humid Subtropical"
        case .cfb: return "Oceanic"
        case .cfc: return "Subpolar Oceanic"
        case .csa: return "Hot-Summer Mediterranean"
        case .csb: return "Warm-Summer Mediterranean"
        case .cwa: return "Monsoon Subtropical"
        case .cwb: return "Subtropical Highland"
        case .dfa: return "Hot-Summer Continental"
        case .dfb: return "Warm-Summer Continental"
        case .dfc: return "Subarctic"
        case .dwa: return "Monsoon Hot-Summer Continental"
        case .dwb: return "Monsoon Warm-Summer Continental"
        case .et: return "Tundra"
        case .ef: return "Ice Cap"
        }
    }
    
    var isTropical: Bool {
        switch self {
        case .af, .am, .aw: return true
        default: return false
        }
    }
    
    var isArid: Bool {
        switch self {
        case .bwh, .bwk, .bsh, .bsk: return true
        default: return false
        }
    }
}

struct GardenLocation: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let city: String
    let country: String
    let timeZone: TimeZone
    
    var hemisphere: Hemisphere {
        if abs(latitude) < 23.5 { return .tropical }
        return latitude >= 0 ? .northern : .southern
    }
}

enum TemperatureUnit: String, Codable {
    case celsius
    case fahrenheit
    
    func convert(_ celsius: Double) -> Double {
        switch self {
        case .celsius: return celsius
        case .fahrenheit: return celsius * 9/5 + 32
        }
    }
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}

enum MeasurementSystem: String, Codable {
    case metric
    case imperial
    
    func convertLength(_ cm: Double) -> Double {
        switch self {
        case .metric: return cm
        case .imperial: return cm / 2.54
        }
    }
    
    var lengthUnit: String {
        switch self {
        case .metric: return "cm"
        case .imperial: return "in"
        }
    }
}
