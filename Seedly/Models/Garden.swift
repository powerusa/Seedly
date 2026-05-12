// Garden.swift
// Seedly

import Foundation
import SwiftData

@Model
final class Garden {
    var id: UUID
    var name: String
    var locationLatitude: Double
    var locationLongitude: Double
    var city: String
    var country: String
    var climateZoneId: String
    var gardenType: String // raised bed, container, greenhouse, in-ground
    var createdAt: Date
    var isActive: Bool
    
    @Relationship(deleteRule: .cascade) var plants: [UserPlant]?
    @Relationship(deleteRule: .cascade) var tasks: [GardenTask]?
    
    init(
        name: String,
        locationLatitude: Double,
        locationLongitude: Double,
        city: String,
        country: String,
        climateZoneId: String,
        gardenType: String = "in-ground"
    ) {
        self.id = UUID()
        self.name = name
        self.locationLatitude = locationLatitude
        self.locationLongitude = locationLongitude
        self.city = city
        self.country = country
        self.climateZoneId = climateZoneId
        self.gardenType = gardenType
        self.createdAt = Date()
        self.isActive = true
    }
}

@Model
final class UserPlant {
    var id: UUID
    var plantId: String
    var plantedDate: Date?
    var expectedHarvestDate: Date?
    var status: String // planned, planted, growing, harvesting, dormant
    var notes: String
    var garden: Garden?
    
    init(plantId: String, status: String = "planned") {
        self.id = UUID()
        self.plantId = plantId
        self.status = status
        self.notes = ""
    }
}

@Model
final class UserSettings {
    var id: UUID
    var temperatureUnit: String
    var measurementSystem: String
    var selectedLanguage: String
    var notificationsEnabled: Bool
    var frostAlertsEnabled: Bool
    var wateringRemindersEnabled: Bool
    var plantingRemindersEnabled: Bool
    
    init() {
        self.id = UUID()
        self.temperatureUnit = "celsius"
        self.measurementSystem = "metric"
        self.selectedLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        self.notificationsEnabled = true
        self.frostAlertsEnabled = true
        self.wateringRemindersEnabled = true
        self.plantingRemindersEnabled = true
    }
}
