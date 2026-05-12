// FavoritesStore.swift
// Simple Seeds
//
// Shared store for plant favorites. Persists to UserDefaults and
// publishes changes so any view observing it updates instantly.

import SwiftUI
import Combine

@MainActor
final class FavoritesStore: ObservableObject {
    static let shared = FavoritesStore()
    
    @Published private(set) var favoritePlantIds: Set<String> = []
    
    private let storageKey = "favoritePlants"
    
    init() {
        load()
    }
    
    func isFavorite(_ plantId: String) -> Bool {
        favoritePlantIds.contains(plantId)
    }
    
    func toggle(_ plantId: String) {
        if favoritePlantIds.contains(plantId) {
            favoritePlantIds.remove(plantId)
        } else {
            favoritePlantIds.insert(plantId)
        }
        save()
    }
    
    private func load() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        favoritePlantIds = Set(saved)
    }
    
    private func save() {
        UserDefaults.standard.set(Array(favoritePlantIds), forKey: storageKey)
    }
}
