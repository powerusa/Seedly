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
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        // Use mock location if none set
        let loc = location ?? GardenLocation(
            latitude: 43.07,
            longitude: -89.40,
            city: "Madison",
            country: "United States",
            timeZone: TimeZone(identifier: "America/Chicago")!
        )
        
        self.location = loc
        self.climateZone = climateEngine.determineZone(for: loc)
        self.currentSeason = climateEngine.currentSeason(for: loc)
        
        // Fetch weather
        weather = await weatherService.fetchWeather(for: loc)
        
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
