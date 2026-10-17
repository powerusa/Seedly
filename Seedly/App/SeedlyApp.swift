// SeedlyApp.swift
// Simple Seeds – Global Planting Calendar
// Buy once. Garden forever.

import SwiftUI
import SwiftData

@main
struct SeedlyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var appState = AppState()
    @StateObject private var localization = LocalizationManager.shared
    @StateObject private var favorites = FavoritesStore.shared
    @StateObject private var garden = GardenStore.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Garden.self,
            UserPlant.self,
            GardenTask.self,
            UserSettings.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Fallback to in-memory if persistent store fails
            let fallback = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [fallback])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            Group {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(appState)
                    .environmentObject(localization)
                    .environmentObject(favorites)
                    .environmentObject(garden)
            } else {
                OnboardingView()
                    .environmentObject(appState)
                    .environmentObject(localization)
                    .environmentObject(favorites)
                    .environmentObject(garden)
            }
            }
            .environment(\.locale, Locale(identifier: localization.currentLanguage))
            .environment(\.layoutDirection, localization.currentLanguage == "ar" ? .rightToLeft : .leftToRight)
            .preferredColorScheme(.dark)
            .tint(SeedlyTheme.accentGreen)
        }
        .modelContainer(sharedModelContainer)
    }
}
