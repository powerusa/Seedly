// WeatherService.swift
// Seedly

import Foundation
import WeatherKit
import CoreLocation

actor WeatherService {
    
    private var cachedWeather: WeatherData?
    private var lastFetchDate: Date?
    private let cacheValidityMinutes: Int = 30
    
    // MARK: - Fetch Weather
    func fetchWeather(for location: GardenLocation) async -> WeatherData? {
        // Check cache validity
        if let cached = cachedWeather,
           let lastFetch = lastFetchDate,
           Date().timeIntervalSince(lastFetch) < Double(cacheValidityMinutes * 60) {
            return cached
        }
        
        // In production, use WeatherKit API
        // For now, generate realistic mock data based on location
        let weather = generateMockWeather(for: location)
        cachedWeather = weather
        lastFetchDate = Date()
        return weather
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
    
    // MARK: - Mock Weather Generation
    private func generateMockWeather(for location: GardenLocation) -> WeatherData {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())
        let isNorthern = location.hemisphere == .northern
        
        // Seasonal temperature adjustment
        let baseTemp: Double
        
        let isWinter: Bool
        let isSpring: Bool
        let isSummer: Bool
        
        if isNorthern {
            isWinter = month == 12 || month == 1 || month == 2
            isSpring = month >= 3 && month <= 5
            isSummer = month >= 6 && month <= 8
        } else {
            isWinter = month >= 6 && month <= 8
            isSpring = month >= 9 && month <= 11
            isSummer = month == 12 || month == 1 || month == 2
        }
        
        if isWinter {
            baseTemp = 2
        } else if isSpring {
            baseTemp = 14
        } else if isSummer {
            baseTemp = 25
        } else {
            baseTemp = 16
        }
        
        let currentTemp = baseTemp + Double.random(in: -3...3)
        let highTemp = currentTemp + Double.random(in: 3...8)
        let lowTemp = currentTemp - Double.random(in: 3...8)
        
        let conditions: [WeatherCondition] = [.sunny, .partlyCloudy, .cloudy, .lightRain]
        let condition = conditions.randomElement() ?? .partlyCloudy
        
        // Generate 7-day forecast
        var forecast: [DayForecast] = []
        for i in 1...7 {
            let date = calendar.date(byAdding: .day, value: i, to: Date())!
            let dayHigh = highTemp + Double.random(in: -4...4)
            let dayLow = lowTemp + Double.random(in: -3...3)
            let dayCondition = conditions.randomElement() ?? .partlyCloudy
            
            forecast.append(DayForecast(
                date: date,
                highTemp: dayHigh,
                lowTemp: dayLow,
                condition: dayCondition,
                precipitationMm: dayCondition == .lightRain ? Double.random(in: 2...15) : 0,
                precipitationChance: dayCondition == .lightRain ? Int.random(in: 40...80) : Int.random(in: 0...20),
                humidity: Int.random(in: 40...75),
                windSpeedKmh: Double.random(in: 5...25),
                uvIndex: Int.random(in: 2...8)
            ))
        }
        
        return WeatherData(
            location: location.city,
            currentTemp: currentTemp,
            feelsLike: currentTemp - 2,
            highTemp: highTemp,
            lowTemp: lowTemp,
            humidity: Int.random(in: 40...75),
            windSpeedKmh: Double.random(in: 5...20),
            uvIndex: Int.random(in: 2...8),
            condition: condition,
            precipitationMm: condition == .lightRain ? Double.random(in: 1...10) : 0,
            precipitationChance: condition == .lightRain ? Int.random(in: 40...70) : Int.random(in: 0...15),
            sunrise: calendar.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!,
            sunset: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!,
            forecast: forecast,
            lastUpdated: Date()
        )
    }
}
