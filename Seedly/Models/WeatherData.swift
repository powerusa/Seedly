// WeatherData.swift
// Seedly

import Foundation
import SwiftUI

struct WeatherData: Codable {
    let location: String
    let currentTemp: Double
    let feelsLike: Double
    let highTemp: Double
    let lowTemp: Double
    let humidity: Int
    let windSpeedKmh: Double
    let uvIndex: Int
    let condition: WeatherCondition
    let precipitationMm: Double
    let precipitationChance: Int
    let sunrise: Date
    let sunset: Date
    let forecast: [DayForecast]
    let lastUpdated: Date
    
    var hasFrostRisk: Bool {
        lowTemp <= 2.0 || forecast.first(where: { $0.lowTemp <= 0 }) != nil
    }
    
    var hasHeatRisk: Bool {
        highTemp >= 35.0
    }
    
    var hasRainExpected: Bool {
        precipitationChance > 60 || forecast.prefix(2).contains(where: { $0.precipitationChance > 60 })
    }
}

struct DayForecast: Codable, Identifiable {
    let id: UUID
    let date: Date
    let highTemp: Double
    let lowTemp: Double
    let condition: WeatherCondition
    let precipitationMm: Double
    let precipitationChance: Int
    let humidity: Int
    let windSpeedKmh: Double
    let uvIndex: Int
    
    var hasFrostRisk: Bool { lowTemp <= 0 }
    var hasHeatRisk: Bool { highTemp >= 35 }
    
    init(
        date: Date,
        highTemp: Double,
        lowTemp: Double,
        condition: WeatherCondition,
        precipitationMm: Double = 0,
        precipitationChance: Int = 0,
        humidity: Int = 50,
        windSpeedKmh: Double = 10,
        uvIndex: Int = 5
    ) {
        self.id = UUID()
        self.date = date
        self.highTemp = highTemp
        self.lowTemp = lowTemp
        self.condition = condition
        self.precipitationMm = precipitationMm
        self.precipitationChance = precipitationChance
        self.humidity = humidity
        self.windSpeedKmh = windSpeedKmh
        self.uvIndex = uvIndex
    }
}

enum WeatherCondition: String, Codable {
    case sunny
    case partlyCloudy
    case cloudy
    case overcast
    case lightRain
    case rain
    case heavyRain
    case thunderstorm
    case snow
    case sleet
    case fog
    case windy
    case hail
    
    var icon: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .overcast: return "smoke.fill"
        case .lightRain: return "cloud.drizzle.fill"
        case .rain: return "cloud.rain.fill"
        case .heavyRain: return "cloud.heavyrain.fill"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .sleet: return "cloud.sleet.fill"
        case .fog: return "cloud.fog.fill"
        case .windy: return "wind"
        case .hail: return "cloud.hail.fill"
        }
    }
    
    var description: LocalizedStringKey {
        LocalizedStringKey("weather_\(rawValue)")
    }
    
    var localizedDisplayName: String {
        let lang = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let names: [String: [WeatherCondition: String]] = [
            "pl": [.sunny: "Słonecznie", .partlyCloudy: "Częściowe zachmurzenie", .cloudy: "Pochmurnie", .overcast: "Zachmurzenie", .lightRain: "Lekki deszcz", .rain: "Deszcz", .heavyRain: "Ulewny deszcz", .thunderstorm: "Burza", .snow: "Śnieg", .sleet: "Deszcz ze śniegiem", .fog: "Mgła", .windy: "Wietrznie", .hail: "Grad"],
            "es": [.sunny: "Soleado", .partlyCloudy: "Parcialmente nublado", .cloudy: "Nublado", .overcast: "Cubierto", .lightRain: "Llovizna", .rain: "Lluvia", .heavyRain: "Lluvia fuerte", .thunderstorm: "Tormenta", .snow: "Nieve", .sleet: "Aguanieve", .fog: "Niebla", .windy: "Ventoso", .hail: "Granizo"],
            "de": [.sunny: "Sonnig", .partlyCloudy: "Teilweise bewölkt", .cloudy: "Bewölkt", .overcast: "Bedeckt", .lightRain: "Leichter Regen", .rain: "Regen", .heavyRain: "Starkregen", .thunderstorm: "Gewitter", .snow: "Schnee", .sleet: "Schneeregen", .fog: "Nebel", .windy: "Windig", .hail: "Hagel"],
            "fr": [.sunny: "Ensoleillé", .partlyCloudy: "Partiellement nuageux", .cloudy: "Nuageux", .overcast: "Couvert", .lightRain: "Bruine", .rain: "Pluie", .heavyRain: "Forte pluie", .thunderstorm: "Orage", .snow: "Neige", .sleet: "Grésil", .fog: "Brouillard", .windy: "Venteux", .hail: "Grêle"],
            "it": [.sunny: "Soleggiato", .partlyCloudy: "Parzialmente nuvoloso", .cloudy: "Nuvoloso", .overcast: "Coperto", .lightRain: "Pioggerella", .rain: "Pioggia", .heavyRain: "Pioggia forte", .thunderstorm: "Temporale", .snow: "Neve", .sleet: "Nevischio", .fog: "Nebbia", .windy: "Ventoso", .hail: "Grandine"],
            "ja": [.sunny: "晴れ", .partlyCloudy: "曇り時々晴れ", .cloudy: "曇り", .overcast: "どんより", .lightRain: "小雨", .rain: "雨", .heavyRain: "大雨", .thunderstorm: "雷雨", .snow: "雪", .sleet: "みぞれ", .fog: "霧", .windy: "風", .hail: "雹"],
        ]
        if let localized = names[lang]?[self] { return localized }
        return rawValue.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression).capitalized
    }
    
    var gardeningImpact: GardeningImpact {
        switch self {
        case .sunny: return .excellent
        case .partlyCloudy: return .good
        case .cloudy: return .good
        case .overcast: return .fair
        case .lightRain: return .fair
        case .rain: return .poor
        case .heavyRain: return .poor
        case .thunderstorm: return .avoid
        case .snow: return .avoid
        case .sleet: return .avoid
        case .fog: return .fair
        case .windy: return .fair
        case .hail: return .avoid
        }
    }
}

enum GardeningImpact: String {
    case excellent
    case good
    case fair
    case poor
    case avoid
    
    var color: String {
        switch self {
        case .excellent: return "green"
        case .good: return "teal"
        case .fair: return "yellow"
        case .poor: return "orange"
        case .avoid: return "red"
        }
    }
    
    var displayName: LocalizedStringKey {
        LocalizedStringKey("impact_\(rawValue)")
    }
}

// MARK: - Garden Insight
struct GardenInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let title: String
    let subtitle: String
    let icon: String
    let priority: Int
    let actionable: Bool
    
    enum InsightType {
        case planting
        case frost
        case rain
        case heat
        case harvest
        case watering
        case wind
        case general
        
        var color: String {
            switch self {
            case .planting: return "green"
            case .frost: return "blue"
            case .rain: return "cyan"
            case .heat: return "orange"
            case .harvest: return "red"
            case .watering: return "teal"
            case .wind: return "gray"
            case .general: return "purple"
            }
        }
    }
}
