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
        let lang = LocalizationManager.shared.currentLanguage
        formatter.locale = Locale(identifier: lang)
        formatter.dateFormat = "LLLL yyyy"  // standalone month ("styczeń 2026" vs "stycznia 2026")
        let raw = formatter.string(from: currentMonth)
        // Polish standalone month is lowercase — capitalize first letter for display
        return raw.prefix(1).localizedCapitalized + raw.dropFirst()
    }
    
    /// Short weekday labels starting from Monday, in the selected app language.
    var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        let lang = LocalizationManager.shared.currentLanguage
        formatter.locale = Locale(identifier: lang)
        // shortStandaloneWeekdaySymbols = [Sun, Mon, Tue, Wed, Thu, Fri, Sat]; we want Mon-first
        let symbols = formatter.shortStandaloneWeekdaySymbols ?? ["S","M","T","W","T","F","S"]
        let reordered = Array(symbols.dropFirst()) + [symbols[0]]
        return reordered.map { $0.prefix(1).localizedCapitalized + $0.dropFirst() }
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
    
    // MARK: - Forward-looking recommendations (driven by selectedDate)
    
    /// Plants ready to sow/transplant within `days` days starting from the
    /// currently selected date. Dedup'd by plant, sorted by soonest.
    func upcomingPlantings(within days: Int = 14, limit: Int = 4) -> [CalendarRecommendation] {
        recommendations(
            eventTypes: [.planting, .seedStart, .transplant],
            fromOffset: 0,
            toOffset: days,
            limit: limit
        )
    }
    
    /// Events occurring farther out from the selected date (default: between
    /// 14 and 90 days). Used for the "Coming Up" preview list.
    func comingUpEvents(afterDays: Int = 14, throughDays: Int = 90, limit: Int = 4) -> [CalendarRecommendation] {
        recommendations(
            eventTypes: nil,
            fromOffset: afterDays,
            toOffset: throughDays,
            limit: limit
        )
    }
    
    private func recommendations(eventTypes: Set<PlantingEventType>?,
                                 fromOffset: Int,
                                 toOffset: Int,
                                 limit: Int) -> [CalendarRecommendation] {
        let cal = Calendar.current
        let anchor = cal.startOfDay(for: selectedDate)
        guard let lo = cal.date(byAdding: .day, value: fromOffset, to: anchor),
              let hi = cal.date(byAdding: .day, value: toOffset,   to: anchor)
        else { return [] }
        
        let lang = LocalizationManager.shared.currentLanguage
        var seen = Set<String>()
        var out: [CalendarRecommendation] = []
        
        let candidates = plantingEvents
            .filter { event in
                if let types = eventTypes, !types.contains(event.eventType) { return false }
                let d = cal.startOfDay(for: event.date)
                return d >= lo && d <= hi
            }
            .sorted { $0.date < $1.date }
        
        for event in candidates {
            let key = "\(event.plantId)|\(event.eventType.rawValue)"
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            let days = cal.dateComponents([.day], from: anchor, to: cal.startOfDay(for: event.date)).day ?? 0
            let name = PlantDatabase.shared.plant(byId: event.plantId)?.localizedName(for: lang) ?? event.plantName
            out.append(CalendarRecommendation(
                plantId: event.plantId,
                plantName: name,
                daysFromSelected: days,
                eventType: event.eventType
            ))
            if out.count >= limit { break }
        }
        return out
    }
}

// MARK: - Recommendation Model

struct CalendarRecommendation: Identifiable, Hashable {
    let id = UUID()
    let plantId: String
    let plantName: String
    let daysFromSelected: Int
    let eventType: PlantingEventType
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
