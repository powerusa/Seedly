// CalendarViewModel.swift
// Seedly

import SwiftUI
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Date = Date()
    @Published var plantingEvents: [PlantingEvent] = []
    @Published var selectedDayPlants: [PlantingEvent] = []
    
    private let plantingEngine = PlantingEngine()
    private let climateEngine = ClimateEngine()
    private let plantDatabase = PlantDatabase.shared
    
    var monthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var daysInMonth: [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentMonth)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        
        return range.map { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
        }
    }
    
    var weekdayOffset: Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let weekday = calendar.component(.weekday, from: startOfMonth)
        return (weekday + 5) % 7  // Monday start
    }
    
    func loadEvents() {
        let calendar = Calendar.current
        let location = GardenLocation(
            latitude: 43.07, longitude: -89.40,
            city: "Madison", country: "US",
            timeZone: .current
        )
        let zone = climateEngine.determineZone(for: location)
        
        var events: [PlantingEvent] = []
        
        for plant in plantDatabase.allPlants {
            let schedule = plantingEngine.calculatePlantingWindow(for: plant, in: zone, weather: nil)
            
            // Add outdoor planting event
            events.append(PlantingEvent(
                plantId: plant.id,
                plantName: plant.localizedName(),
                eventType: .planting,
                date: schedule.outdoorPlantDate,
                color: .green
            ))
            
            // Add harvest event
            events.append(PlantingEvent(
                plantId: plant.id,
                plantName: plant.localizedName(),
                eventType: .harvest,
                date: schedule.expectedHarvestDate,
                color: .orange
            ))
            
            // Add indoor seed start if applicable
            if let indoorDate = schedule.indoorSeedStart {
                events.append(PlantingEvent(
                    plantId: plant.id,
                    plantName: plant.localizedName(),
                    eventType: .seedStart,
                    date: indoorDate,
                    color: .purple
                ))
            }
        }
        
        plantingEvents = events
        updateSelectedDayPlants()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        updateSelectedDayPlants()
    }
    
    func nextMonth() {
        let calendar = Calendar.current
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    func previousMonth() {
        let calendar = Calendar.current
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func eventsForDate(_ date: Date) -> [PlantingEvent] {
        let calendar = Calendar.current
        return plantingEvents.filter { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
    
    func hasEvents(on date: Date) -> Bool {
        !eventsForDate(date).isEmpty
    }
    
    private func updateSelectedDayPlants() {
        selectedDayPlants = eventsForDate(selectedDate)
    }
}

struct PlantingEvent: Identifiable {
    let id = UUID()
    let plantId: String
    let plantName: String
    let eventType: PlantingEventType
    let date: Date
    let color: Color
}

enum PlantingEventType: String {
    case seedStart = "Start Seeds"
    case planting = "Plant Outdoors"
    case transplant = "Transplant"
    case harvest = "Harvest"
    
    var icon: String {
        switch self {
        case .seedStart: return "sparkle"
        case .planting: return "leaf.fill"
        case .transplant: return "arrow.right"
        case .harvest: return "basket.fill"
        }
    }
}
