// AppState.swift
// Seedly

import SwiftUI
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: TabItem = .today
    @Published var currentLocation: GardenLocation?
    @Published var currentWeather: WeatherData?
    @Published var climateZone: ClimateZone?
    @Published var isLoadingWeather = false
    @Published var temperatureUnit: TemperatureUnit = .celsius
    @Published var measurementUnit: MeasurementSystem = .metric
    
    private let locationService = LocationService()
    private let weatherService = WeatherService()
    private let climateEngine = ClimateEngine()
    
    init() {
        loadUserPreferences()
    }
    
    func refreshWeather() async {
        isLoadingWeather = true
        defer { isLoadingWeather = false }
        
        if let location = currentLocation {
            currentWeather = await weatherService.fetchWeather(for: location)
            climateZone = climateEngine.determineZone(for: location)
        }
    }
    
    func updateLocation(_ location: GardenLocation) {
        currentLocation = location
        climateZone = climateEngine.determineZone(for: location)
        Task {
            await refreshWeather()
        }
    }
    
    private func loadUserPreferences() {
        if let savedUnit = UserDefaults.standard.string(forKey: "temperatureUnit") {
            temperatureUnit = TemperatureUnit(rawValue: savedUnit) ?? .celsius
        }
        if let savedMeasurement = UserDefaults.standard.string(forKey: "measurementUnit") {
            measurementUnit = MeasurementSystem(rawValue: savedMeasurement) ?? .metric
        }
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case calendar = "Calendar"
    case plants = "Plants"
    case tasks = "Tasks"
    case more = "More"
    
    var icon: String {
        switch self {
        case .today: return "leaf.fill"
        case .calendar: return "calendar"
        case .plants: return "camera.macro"
        case .tasks: return "checklist"
        case .more: return "ellipsis.circle"
        }
    }
    
    var localizedTitle: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}
