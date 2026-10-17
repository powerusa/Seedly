// WeatherService.swift
// Seedly

import Foundation
import WeatherKit
import CoreLocation

actor WeatherService {
    
    private var cachedWeather: WeatherData?
    private var cachedLocation: CLLocation?
    private var lastFetchDate: Date?
    private let cacheValidityMinutes: Int = 30
    private let cacheDistanceMeters: CLLocationDistance = 1_000
    private let weatherKit = WeatherKit.WeatherService.shared
    
    // MARK: - Fetch Weather
    func fetchWeather(for location: GardenLocation) async -> WeatherData? {
        // Check cache validity
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        if let cached = cachedWeather,
           let cachedLocation,
           let lastFetch = lastFetchDate,
           Date().timeIntervalSince(lastFetch) < Double(cacheValidityMinutes * 60),
           cachedLocation.distance(from: clLocation) < cacheDistanceMeters {
            return cached
        }
        
        // Fetch real weather from WeatherKit
        do {
            let weather = try await weatherKit.weather(for: clLocation, including: .current, .daily)
            
            let weatherData = mapWeatherKitData(
                current: weather.0,
                daily: weather.1,
                location: location
            )
            
            cachedWeather = weatherData
            cachedLocation = clLocation
            lastFetchDate = Date()
            return weatherData
            
        } catch {
            print("WeatherKit error: \(error)")
            // A failed weather request must not become a fabricated forecast or frost alert.
            return nil
        }
    }
    
    // MARK: - Map WeatherKit Data
    private nonisolated func mapWeatherKitData(
        current: WeatherKit.CurrentWeather,
        daily: WeatherKit.Forecast<WeatherKit.DayWeather>,
        location: GardenLocation
    ) -> WeatherData {
        let calendar = Calendar.current
        
        // Map current weather condition
        let condition = mapWeatherKitCondition(current.condition)
        
        // Map 7-day forecast
        var forecast: [DayForecast] = []
        for day in daily.forecast.prefix(7) {
            forecast.append(DayForecast(
                date: day.date,
                highTemp: day.highTemperature.converted(to: .celsius).value,
                lowTemp: day.lowTemperature.converted(to: .celsius).value,
                condition: mapWeatherKitCondition(day.condition),
                precipitationMm: day.precipitationAmountByType.precipitation.value,
                precipitationChance: Int(day.precipitationChance * 100),
                humidity: 50,
                windSpeedKmh: day.wind.speed.converted(to: .kilometersPerHour).value,
                uvIndex: day.uvIndex.value
            ))
        }
        
        return WeatherData(
            location: location.city,
            currentTemp: current.temperature.converted(to: .celsius).value,
            feelsLike: current.apparentTemperature.converted(to: .celsius).value,
            highTemp: daily.forecast.first?.highTemperature.value ?? current.temperature.converted(to: .celsius).value + 5,
            lowTemp: daily.forecast.first?.lowTemperature.value ?? current.temperature.converted(to: .celsius).value - 5,
            humidity: Int(current.humidity * 100),
            windSpeedKmh: current.wind.speed.converted(to: .kilometersPerHour).value,
            uvIndex: current.uvIndex.value,
            condition: condition,
            precipitationMm: daily.forecast.first?.precipitationAmountByType.precipitation.value ?? 0,
            precipitationChance: Int((daily.forecast.first?.precipitationChance ?? 0) * 100),
            sunrise: daily.forecast.first?.sun.sunrise ?? calendar.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!,
            sunset: daily.forecast.first?.sun.sunset ?? calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!,
            forecast: forecast,
            lastUpdated: Date()
        )
    }
    
    private nonisolated func mapWeatherKitCondition(_ condition: WeatherKit.WeatherCondition) -> WeatherCondition {
        switch condition {
        case .clear, .mostlyClear:
            return .sunny
        case .partlyCloudy:
            return .partlyCloudy
        case .mostlyCloudy, .cloudy:
            return .cloudy
        case .foggy:
            return .fog
        case .haze:
            return .overcast
        case .drizzle, .rain, .heavyRain:
            return .rain
        case .sunShowers:
            return .lightRain
        case .freezingRain, .sleet:
            return .sleet
        case .snow, .heavySnow:
            return .snow
        case .thunderstorms, .strongStorms:
            return .thunderstorm
        case .windy, .breezy:
            return .windy
        case .hail:
            return .hail
        default:
            return .partlyCloudy
        }
    }
    
    // MARK: - Generate Insights
    nonisolated func generateInsights(weather: WeatherData, plants: [Plant]) -> [GardenInsight] {
        var insights: [GardenInsight] = []
        
        // Frost alert
        if weather.hasFrostRisk {
            insights.append(GardenInsight(
                type: .frost,
                title: String(localized: "insight_frost_title"),
                subtitle: String(localized: "insight_frost_subtitle"),
                icon: "thermometer.snowflake",
                priority: 1,
                actionable: true
            ))
        }
        
        // Heat alert
        if weather.hasHeatRisk {
            insights.append(GardenInsight(
                type: .heat,
                title: String(localized: "insight_heat_title"),
                subtitle: String(localized: "insight_heat_subtitle"),
                icon: "thermometer.sun.fill",
                priority: 1,
                actionable: true
            ))
        }
        
        // Rain insight
        if weather.hasRainExpected {
            insights.append(GardenInsight(
                type: .rain,
                title: String(localized: "insight_rain_title"),
                subtitle: String(localized: "insight_rain_subtitle"),
                icon: "cloud.rain.fill",
                priority: 2,
                actionable: false
            ))
        }
        
        // Planting conditions
        if !weather.hasFrostRisk && !weather.hasHeatRisk && weather.condition.gardeningImpact == .excellent {
            insights.append(GardenInsight(
                type: .planting,
                title: String(localized: "insight_perfect_title"),
                subtitle: String(localized: "insight_perfect_subtitle"),
                icon: "leaf.fill",
                priority: 3,
                actionable: true
            ))
        }
        
        // Watering insight
        if !weather.hasRainExpected && weather.humidity < 40 {
            insights.append(GardenInsight(
                type: .watering,
                title: String(localized: "insight_water_title"),
                subtitle: String(localized: "insight_water_subtitle"),
                icon: "drop.fill",
                priority: 3,
                actionable: true
            ))
        }
        
        // Wind warning
        if weather.windSpeedKmh > 40 {
            insights.append(GardenInsight(
                type: .wind,
                title: String(localized: "insight_wind_title"),
                subtitle: String(localized: "insight_wind_subtitle"),
                icon: "wind",
                priority: 2,
                actionable: true
            ))
        }
        
        return insights.sorted { $0.priority < $1.priority }
    }
    
}
