// Constants.swift
// Seedly

import Foundation

enum AppConstants {
    static let appName = "Simple Seeds"
    static let appSubtitle = "Global Planting Calendar"
    static let tagline = "Buy once. Garden forever."
    static let version = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - App Store
    static let appStoreTitle = "Simple Seeds – Global Planting Calendar"
    static let appStoreSubtitle = "Plan. Plant. Grow."
    static let appPrice = "$14.99"
    
    // MARK: - Bundle IDs
    static let mainBundleID = "com.seedly.app"
    static let widgetBundleID = "com.seedly.app.widgets"
    
    // MARK: - UserDefaults Keys
    enum UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedLanguage = "selectedLanguage"
        static let temperatureUnit = "temperatureUnit"
        static let measurementUnit = "measurementUnit"
        static let gardeningExperience = "gardeningExperience"
        static let favoritePlants = "favoritePlants"
        static let lastWeatherUpdate = "lastWeatherUpdate"
        static let notificationsEnabled = "notificationsEnabled"
        static let frostAlertsEnabled = "frostAlertsEnabled"
        static let wateringRemindersEnabled = "wateringRemindersEnabled"
    }
    
    // MARK: - Notification Identifiers
    enum NotificationCategories {
        static let frostAlert = "FROST_ALERT"
        static let heatAlert = "HEAT_ALERT"
        static let wateringReminder = "WATERING_REMINDER"
        static let plantingReminder = "PLANTING_REMINDER"
        static let harvestReminder = "HARVEST_REMINDER"
        static let severeWeather = "SEVERE_WEATHER"
    }
    
    // MARK: - Cache Durations
    enum CacheDuration {
        static let weatherMinutes = 30
        static let plantDatabaseHours = 24
        static let locationMinutes = 60
    }
    
    // MARK: - Supported Locales
    static let supportedLocales = [
        "en", "pl", "es", "de", "fr",
        "it", "pt", "nl", "ja", "ko",
        "zh", "ar", "hi", "uk", "ru"
    ]
    
    // MARK: - Privacy
    enum Privacy {
        static let privacyPolicyURL = "https://seedly.app/privacy"
        static let termsURL = "https://seedly.app/terms"
        static let dataCollectionStatement = """
        Simple Seeds collects NO personal data. Your location is used only on-device \
        to provide accurate planting calendars. No data is sent to any server. \
        No account required. No tracking. No analytics.
        """
    }
    
    // MARK: - Animation
    enum Animation {
        static let quickDuration = 0.2
        static let standardDuration = 0.3
        static let slowDuration = 0.5
        static let springResponse = 0.4
        static let springDamping = 0.8
    }
}
