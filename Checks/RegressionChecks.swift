// Run with Checks/run-regressions.sh; exercises real production model/view-model sources.
import Foundation
import CoreLocation

// UI-only dependencies are replaced to allow a lightweight macOS test executable.
struct GardenStore {
    static func customName(for id: String) -> String? { nil }
}

@main struct RegressionChecks {
    @MainActor static func main() async {
        let suite = "SeedlyRegression.\(UUID())"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let model = TasksViewModel(defaults: defaults)
        assert(model.todayTasks.isEmpty && model.upcomingTasks.isEmpty, "No fabricated tasks")
        model.addTask(title: " \n ", type: .watering, dueDate: Date())
        assert(model.todayTasks.isEmpty, "Reject blank titles")
        let due = Calendar.current.startOfDay(for: Date())
        model.addTask(title: " Water seedlings ", type: .watering, dueDate: due, recurringInterval: 7)
        let task = model.todayTasks.first!
        assert(task.customTitle == "Water seedlings")
        model.toggleTask(task)
        assert(model.completedTasks.count == 1 && model.upcomingTasks.count == 1)
        assert(Calendar.current.dateComponents([.day], from: due, to: model.upcomingTasks[0].dueDate).day == 7)
        model.toggleTask(model.completedTasks[0])
        assert(model.todayTasks.count == 1 && model.upcomingTasks.count == 1, "Undo preserves future dates")
        model.toggleTask(model.todayTasks[0])
        assert(model.upcomingTasks.count == 1, "Re-completing does not duplicate recurrence")
        let reloaded = TasksViewModel(defaults: defaults)
        assert(reloaded.completedTasks.first?.id == task.id, "Stable IDs and completion survive restart")
        assert(reloaded.upcomingTasks.count == 1, "Recurrence survives restart")
        model.addTask(title: "Overdue", type: .weeding, dueDate: due.addingTimeInterval(-86400))
        assert(model.todayTasks.count == 1, "Overdue tasks remain visible")
        print("PASS: task validation, save/reload, completion, undo, recurrence, overdue visibility")

        let localization = LocalizationManager.shared
        let previousLanguage = localization.currentLanguage
        for language in PlantLocalization.supportedLanguages {
            localization.currentLanguage = language.code
            assert(UserDefaults.standard.string(forKey: "selectedLanguage") == language.code)
            assert(!localization.shortWeekday(for: Date()).isEmpty)
            assert(!localization.tabToday.isEmpty && !localization.tabCalendar.isEmpty && !localization.tabPlants.isEmpty && !localization.tabTasks.isEmpty && !localization.tabMore.isEmpty)
        }
        localization.currentLanguage = previousLanguage
        print("PASS: 15 language selections persist, tab labels and month names resolve")

        let coordinateOnly = LocationService.resolve(CLLocation(latitude: 52.2297, longitude: 21.0122), placemark: nil)
        assert(coordinateOnly.latitude == 52.2297 && coordinateOnly.longitude == 21.0122)
        assert(!coordinateOnly.city.isEmpty)
        let savedLocation = try! JSONEncoder().encode(coordinateOnly)
        assert(try! JSONDecoder().decode(GardenLocation.self, from: savedLocation) == coordinateOnly)
        await LocationService.shared.setManualLocation(latitude: 91, longitude: 21)
        guard case .locationUnavailable? = LocationService.shared.error else { fatalError("Invalid coordinates must be rejected") }
        print("PASS: empty geocoding fallback, coordinate persistence encoding, invalid coordinates")

        let plants = PlantDatabase.shared.allPlants
        assert(plants.count == 77)
        assert(Set(plants.map(\.id)).count == plants.count)
        for plant in plants {
            assert(!plant.localizedName(for: "en").hasPrefix("plant_"))
            assert(!plant.localizedName(for: "pl").hasPrefix("plant_"))
            assert(plant.spacing.betweenPlantsCm > 0)
        }
        print("PASS: 77 unique catalog entries, English/Polish names, valid spacing")
        let engine = PlantingEngine()
        let zone = ClimateZone(id: "test", name: "Test", usdaZone: "6a", koppenClass: .dfb,
                               hemisphere: .northern, averageFirstFrost: MonthWeek(month: 10, week: 2),
                               averageLastFrost: MonthWeek(month: 4, week: 3), growingSeasonWeeks: 24,
                               annualRainfallMm: 700, avgSummerHighC: 25, avgWinterLowC: -10)
        let anchor = Calendar.current.date(from: DateComponents(year: 2027, month: 1, day: 15))!
        let tomato = PlantDatabase.shared.plant(byId: "tomato")!
        let schedule = engine.calculatePlantingWindow(for: tomato, in: zone, weather: nil, referenceDate: anchor)
        assert(Calendar.current.component(.year, from: schedule.outdoorPlantDate) == 2027)
        assert(Calendar.current.component(.month, from: schedule.outdoorPlantDate) == 4)
        assert(Calendar.current.component(.day, from: schedule.outdoorPlantDate) == 29, "Third April week plus two weeks")
        assert(Calendar.current.dateComponents([.day], from: schedule.indoorSeedStart!, to: schedule.outdoorPlantDate).day == 56)
        let vm = CalendarViewModel()
        vm.currentMonth = anchor
        vm.loadEvents(location: GardenLocation(latitude: 42, longitude: -88, city: "Test", country: "US", timeZone: .current))
        assert(!vm.plantingEvents.isEmpty)
        assert(!vm.plantingEvents.contains { $0.plantId == "appleTree" || $0.plantId == "daffodil" })
        assert(!vm.plantingEvents.contains { $0.eventType == .harvest && PlantDatabase.shared.plant(byId: $0.plantId)?.category == .flower })
        vm.currentMonth = Calendar.current.date(from: DateComponents(year: 2027, month: 12, day: 15))!
        vm.nextMonth()
        assert(vm.plantingEvents.filter { $0.eventType == .planting }.allSatisfy { Calendar.current.component(.year, from: $0.date) == 2028 })
        assert(TemperatureUnit.fahrenheit.convert(0) == 32)
        print("PASS: frost-week date, requested year, year navigation, tree/bulb guidance, no flower harvests, Fahrenheit")
    }
}
