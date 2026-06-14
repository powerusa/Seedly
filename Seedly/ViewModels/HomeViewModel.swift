// HomeViewModel.swift
// Seedly

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var insights: [GardenInsight] = []
    @Published var recommendations: [PlantRecommendation] = []
    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var currentSeason: Season = .spring
    @Published var location: GardenLocation?
    @Published var climateZone: ClimateZone?
    
    private let plantingEngine = PlantingEngine()
    private let weatherService = WeatherService()
    private let climateEngine = ClimateEngine()
    private let plantDatabase = PlantDatabase.shared
    
    func loadData(location: GardenLocation?, weather appWeather: WeatherData?) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let loc = location else {
            self.location = nil
            self.climateZone = nil
            self.weather = nil
            self.insights = []
            self.recommendations = []
            return
        }
        
        self.location = loc
        self.climateZone = climateEngine.determineZone(for: loc)
        self.currentSeason = climateEngine.currentSeason(for: loc)
        
        // Prefer app-level weather so Today stays in sync with the current phone location.
        if let appWeather {
            weather = appWeather
        } else {
            weather = await weatherService.fetchWeather(for: loc)
        }
        
        // Generate insights
        if let weather = weather {
            insights = weatherService.generateInsights(weather: weather, plants: plantDatabase.allPlants)
        }
        
        // Generate recommendations
        if let zone = climateZone {
            recommendations = plantingEngine.todayRecommendations(
                plants: plantDatabase.allPlants,
                zone: zone,
                weather: weather
            )
        }
    }
    
    var temperatureString: String {
        guard let weather = weather else { return "--" }
        return "\(Int(weather.currentTemp))°"
    }
    
    var highLowString: String {
        guard let weather = weather else { return "" }
        return "H \(Int(weather.highTemp))° L \(Int(weather.lowTemp))°"
    }
    
    var conditionString: String {
        weather?.condition.rawValue.capitalized ?? "Loading..."
    }
    
    var frostForecast: [DayForecast] {
        weather?.forecast.prefix(5).map { $0 } ?? []
    }
}
